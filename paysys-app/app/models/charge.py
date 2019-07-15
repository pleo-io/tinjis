from datetime import datetime
from .. import db
from ..exceptions import ValidationError
from flask import url_for, current_app, g

class Charge(db.Model):
    __tablename__ = 'charges'
    id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.Integer())
    currency = db.Column(db.String(64))
    value = db.Column(db.Float())
    result = db.Column(db.Boolean())
    created_on = db.Column(db.DateTime, default=datetime.utcnow)

    
    def get_url(self):
        return url_for('api.get_charge', id=self.id, _external=True)

    def export_data(self):
        return {
            'id': self.id,
            'self_url': self.get_url(),
            'customer_id': self.customer_id,
            'currency': self.currency,
            'value': self.value,
            'result': self.result,
            'created_on': self.created_on,
        }

    def import_data(self, data):
        try:
            self.customer_id = data.get('customer_id')
            self.currency = data.get('currency')
            self.value = data.get('value')
        except KeyError as e:
            raise ValidationError('Invalid customer: missing ' + e.args[0])
        return self