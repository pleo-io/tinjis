# Payment API written in Python using Flask Framework

### How do I get set up? ###

* Environment Setup (Install virtualenv and pip)
	- $ virtualenv venv
	- $ source venv/bin/activate

* Install Dependencies
	- $ pip install -r requirements.txt

* Database configuration 
	- $ python manage.py db init 
	- $ python manage.py initdb 
	- $ python manage.py db migrate 
	- $ python manage.py db upgrade

* Start up the Server
	- $ python run.py

* Main Routes for the projects are stored in the app/api directory under seperate filenames for each module
* To play around a little bit e.g charge an invoice using httpie (http) python client
	- $ pip install httpie (After installation you should have http as command on your computer)
	- $ http post localhost:9000/ customer_id=1 currency=USD value=235
	  

### Who do I talk to? ###

* Repo owner or admin (Bill Morrisson | billmorrissonjr@gmail.com)