import stripe
from flask import Flask, request, json

app = Flask(__name__)

@app.route('/myPaymentEngine', methods=['POST'])
def myPaymentEngine():

    stripe.api_key = "sk_test_ZAthZzlHJWFyPAl9DNRVf3eV"

    json = request.json

    token = json['stripeToken']
    amount = json['amount']
    description = json['description']
    
    try:
        charge = stripe.Charge.create(amount=amount, currency="usd", card=token, description=description)
    except stripe.CardError, e:
        pass

    return "Your payment is done successfully!"

if __name__ == '__main__':
    app.run(host= '0.0.0.0',
            port = 5000)