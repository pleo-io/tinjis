from flask import request, g, jsonify
from . import api
from .. import db, create_app
from ..models import Charge
from ..decorators import json
from flask import url_for, current_app
import random


@api.route('/charges')
@json
def charges():
    charges = Charge.query.all()
    return {'charges': [charge.export_data() for charge in charges]}


@api.route('/get_charge/<int:id>')
@json
def get_charge(id):
    charge = Charge.query.get(id)
    return charge.export_data()

@api.route('/', methods=['POST'])
@json
def pay():
    charge = Charge()
    charge.import_data(request.json)
    charge.result = random.choice([True, False])
    db.session.add(charge)
    db.session.commit()
    return {'charge': charge.export_data()}
