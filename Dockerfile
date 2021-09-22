FROM python:3.8
WORKDIR /coneg-panel-user
COPY /build/web/ .
CMD ["python", "-m", "http.server", "8081"]