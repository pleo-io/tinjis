__author__ = 'CRUCIFIX'


from run import app
from app import db
from flask_script import Manager, prompt_bool
from flask_migrate import Migrate, MigrateCommand

manager = Manager(app)
migrate = Migrate(app, db)


@manager.command
def initdb():
	print "Initialising database"
	db.create_all()

@manager.command
def dropdb():
    if prompt_bool("Are you sure you want to lose all your data"):
        print "Droping database"
        db.drop_all()

manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
