import requests

url = 'http://localhost:8000/TestEmail@example.com'
response = requests.get(url)

print(response.status_code)
print(response.text)