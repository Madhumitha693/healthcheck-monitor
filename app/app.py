from flask import Flask, render_template, request
import requests

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/check', methods=['POST'])
def check():
    url = request.form['url']
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            status = "✅ Site is UP"
        else:
            status = f"⚠️ Site responded with status code {response.status_code}"
    except:
        status = "❌ Site is DOWN or Unreachable"
    return render_template('index.html', result=status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
