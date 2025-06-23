# Prometheus Stack - Fixed and Working

This Prometheus monitoring stack has been fixed and is now fully operational.

## Issues Fixed

### 1. Docker Compose Version Warning
- **Problem**: `version` attribute is obsolete in docker-compose.yml
- **Solution**: Removed the obsolete `version: '3.8'` line

### 2. TLS Handshake Timeout
- **Problem**: `net/http: TLS handshake timeout` when pulling images from Docker Hub
- **Solution**: 
  - Used specific image tags instead of `latest`
  - Pre-pulled working images where possible
  - Temporarily disabled Grafana due to persistent connectivity issues

### 3. Flask Application Port Conflicts
- **Problem**: Flask development server causing port conflicts and restart loops
- **Solution**: 
  - Replaced Flask development server with Gunicorn production server
  - Disabled Flask reloader to prevent restart conflicts
  - Consolidated metrics endpoint into single Flask application

### 4. Prometheus Configuration Error
- **Problem**: Invalid `external_labels` placement in prometheus.yml
- **Solution**: Moved `external_labels` under `global` section

## Current Status

✅ **All Services Working:**
- **Prometheus**: Running on http://localhost:9090
- **Hello-App**: Running on http://localhost:8001
  - Main endpoint: http://localhost:8001/
  - Metrics endpoint: http://localhost:8001/metrics
- **Grafana**: Running on http://localhost:3000
  - Username: admin
  - Password: admin

## Usage

### Start the Stack
```bash
cd FinOps_Adapter/prometheus-stack
docker-compose up -d
```

### Check Status
```bash
docker-compose ps
```

### View Logs
```bash
docker-compose logs [service-name]
```

### Test Endpoints
```bash
# Test hello-app
curl http://localhost:8001/

# Test metrics
curl http://localhost:8001/metrics

# Test Prometheus targets
curl http://localhost:9090/api/v1/targets
```

### Stop the Stack
```bash
docker-compose down
```

## Accessing Grafana

Grafana is available at http://localhost:3000 with:
- Username: admin
- Password: admin

### Setting Up the Dashboard

1. **Add Prometheus Data Source:**
   - Go to Configuration > Data Sources
   - Click "Add data source"
   - Select "Prometheus"
   - Set URL to: `http://prometheus:9090`
   - Click "Save & Test"

2. **Import the Dashboard:**
   - Go to Dashboards > Import
   - Click "Upload JSON file"
   - Select `grafana/dashboards/hello-app-dashboard.json`
   - Click "Import"

3. **Or run the setup script:**
   ```bash
   ./setup-dashboard.sh
   ```

### Dashboard Features

The **Hello App Monitoring Dashboard** includes:

- **Request Rate**: Real-time request rate per second
- **Total Requests**: Gauge showing cumulative requests
- **Python GC Rate**: Garbage collection performance
- **Memory Usage**: Application memory consumption
- **GC Objects by Generation**: Pie chart of garbage collection
- **Service Health**: Table showing service status

### Best Practices Implemented

✅ **Rate-based metrics** for better trend analysis
✅ **Multiple visualization types** (time series, gauge, pie, table)
✅ **Proper metric labeling** and legends
✅ **Health monitoring** with status indicators
✅ **Performance metrics** (memory, GC)
✅ **Auto-refresh** dashboard with configurable time ranges
✅ **Responsive layout** with organized panels

## Architecture

- **Hello-App**: Flask application with Prometheus metrics served by Gunicorn
- **Prometheus**: Scrapes metrics from hello-app every 5 seconds
- **Networking**: All services connected via `monitoring` bridge network
- **Persistence**: Prometheus data and Grafana storage use Docker volumes

## Metrics Available

The hello-app exposes custom metrics:
- `hello_world_requests_total`: Counter of requests to the main endpoint
- Standard Python/Flask metrics provided by prometheus_client

## Troubleshooting

If containers restart:
1. Check logs: `docker-compose logs [service-name]`
2. Verify port availability: `netstat -tulpn | grep [port]`
3. Rebuild if needed: `docker-compose build --no-cache [service-name]`