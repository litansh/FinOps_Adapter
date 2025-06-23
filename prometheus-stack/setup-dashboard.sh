#!/bin/bash

echo "🚀 Setting up Grafana Dashboard for Hello App..."

# Wait for Grafana to be ready
echo "⏳ Waiting for Grafana to be ready..."
until curl -s http://localhost:3000/api/health > /dev/null 2>&1; do
    echo "   Grafana not ready yet, waiting..."
    sleep 2
done

echo "✅ Grafana is ready!"

# Add Prometheus data source
echo "📊 Adding Prometheus data source..."
curl -X POST \
  http://admin:admin@localhost:3000/api/datasources \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "isDefault": true
  }' 2>/dev/null

echo "✅ Prometheus data source added!"

# Import the dashboard
echo "📈 Importing Hello App dashboard..."
curl -X POST \
  http://admin:admin@localhost:3000/api/dashboards/db \
  -H 'Content-Type: application/json' \
  -d @grafana/dashboards/hello-app-dashboard.json 2>/dev/null

echo "✅ Dashboard imported!"

# Generate some sample traffic
echo "🔄 Generating sample traffic..."
for i in {1..10}; do
    curl -s http://localhost:8001/ > /dev/null
    sleep 0.2
done

echo "✅ Sample traffic generated!"

echo ""
echo "🎉 Setup complete! Your monitoring stack is ready:"
echo "   📊 Grafana Dashboard: http://localhost:3000"
echo "   🔍 Prometheus: http://localhost:9090"
echo "   🚀 Hello App: http://localhost:8001"
echo ""
echo "   Login to Grafana with: admin/admin"
echo "   Look for 'Hello App Monitoring Dashboard'"
echo ""