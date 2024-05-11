
import datetime

pyxi = {
    "descrition": "str",
    "medicines": {}
}

def pyxi_created(producer, pyxi):
    print("Debug: ", producer, "\n pix: ", pyxi)
    

def all_pyxis(db, skip, limit):
    for document in db.find():
        print(document)
    

def one_pyxi(db):
    print("Debug: ", db)

def check_pyxi(db, pyxi_id):
    print("Debug: ", db, "\n pix: ", pyxi_id)

def delete_response(db, pyxi_id):
    print("Debug: ", db, "\n pix: ", pyxi_id)



def update_response(db, pyxi_id, pyxi_update):
    print("Debug: ", db, "\n pix: ", pyxi_id, pyxi_update)
