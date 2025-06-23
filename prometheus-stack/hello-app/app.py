from flask import Flask, Response
from prometheus_client import Counter, generate_latest
import prometheus_client

app = Flask(__name__)

REQUEST_COUNT = Counter('hello_world_requests_total', 'Total hello world requests')

@app.route('/')
def hello():
    REQUEST_COUNT.inc()
    return "Hello, Prometheus!"

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')
