from flask import Flask, render_template, request, redirect, url_for
import json
import os

app = Flask(__name__)
DATA_FILE = os.path.join(os.path.dirname(__file__), 'subscriptions.json')

def load_subscriptions():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return []

def save_subscriptions(subs):
    with open(DATA_FILE, 'w') as f:
        json.dump(subs, f, indent=2)

def total_monthly(subs):
    return sum(float(s.get('price', 0)) for s in subs)

@app.route('/', methods=['GET', 'POST'])
def index():
    subs = load_subscriptions()
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        price = float(request.form.get('price'))
        billing_day = request.form.get('billing_day')
        card = request.form.get('card')
        subs.append({
            'name': name,
            'email': email,
            'price': price,
            'billing_day': billing_day,
            'card': card
        })
        save_subscriptions(subs)
        return redirect(url_for('index'))
    total = total_monthly(subs)
    return render_template('index.html', subs=subs, total=total)


@app.route('/metrics')
def metrics():
    subs = load_subscriptions()
    totals = {}
    for s in subs:
        card = s.get('card', 'N/A')
        totals[card] = totals.get(card, 0) + float(s.get('price', 0))
    overall = total_monthly(subs)
    return render_template('metrics.html', totals=totals, overall=overall)

if __name__ == '__main__':
    app.run(debug=True)
