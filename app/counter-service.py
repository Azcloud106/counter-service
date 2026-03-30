from flask import Flask, request, jsonify
import os
import logging
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

COUNTER_FILE = os.getenv("COUNTER_FILE", "/data/counter.txt")

REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP Requests', ['method'])

def ensure_data_dir():
    os.makedirs(os.path.dirname(COUNTER_FILE), exist_ok=True)

def read_counter():
    try:
        if os.path.exists(COUNTER_FILE):
            with open(COUNTER_FILE, "r") as f:
                content = f.read().strip()
                return int(content) if content else 0
        return 0
    except Exception as e:
        app.logger.error(f"Read error: {e}")
        return 0

def update_counter(counter):
    ensure_data_dir()
    with open(COUNTER_FILE, "w") as f:
        f.write(str(counter))

@app.route('/', methods=['GET', 'POST'])
def handle_request():
    REQUEST_COUNT.labels(method=request.method).inc()

    counter = read_counter()

    if request.method == 'POST':
        counter += 1
        update_counter(counter)
        return jsonify({"count": counter})

    return jsonify({"count": counter})

@app.route('/health')
def health():
    try:
        read_counter()
        return jsonify({"status": "healthy"})
    except Exception as e:
        return jsonify({"status": "unhealthy", "error": str(e)}), 500

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080