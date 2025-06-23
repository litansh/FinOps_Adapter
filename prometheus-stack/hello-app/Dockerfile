FROM python:3.10-slim
WORKDIR /app
COPY app.py .
RUN pip install flask prometheus_client gunicorn
EXPOSE 8001
CMD ["gunicorn", "--bind", "0.0.0.0:8001", "app:app"]
