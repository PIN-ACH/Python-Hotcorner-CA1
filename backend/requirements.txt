import os
import psycopg2
import re
from datetime import datetime
from flask import Flask, json, render_template, jsonify, make_response, request
from werkzeug.security import generate_password_hash,check_password_hash
import jwt
#import datetime
from flask_jwt_extended import jwt_required, create_access_token, create_refresh_token, get_jwt_identity, JWTManager
from flask_cors import CORS, cross_origin


app = Flask(__name__)
CORS(app)                #####remove after token is fixed

app.config["JWT_SECRET_KEY"] = "_2GVZxiQ3vwLb63sG9WsN8nL_vMZSKKeKTf9vr0pOovRujg4EDXwmqRIp2uW"  # Change this!
jwt = JWTManager(app)
app.config['JSON_SORT_KEYS'] = False
whitelistIP="http://127.0.0.1"
# replace in payload to new 192.168.198.133:8081
def get_db_connection():
    conn = psycopg2.connect(host='localhost',
                            database='fooddb',
                            user='postgres',
                            password='UserappPass@853')
#                            user='root',
#                            password='Root1385!@sdF')
    return conn
def home():
    date = datetime.now()
    return str(date)


@app.route('/api/v1/product/highlight')
def productHighlight():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT  product.id_product,product.image_url,product.calories,product.description,product.discount_point,product.duration,product.highlight,product.name,product.price,product.status,product.id_category,category.id_category,category.image_url,category.name,category.status FROM product JOIN category on product.id_category=category.id_category where highlight>0 order by highlight asc;')
    opt = cur.fetchall()
    container={}
    products={}
    keydata={}
    Results=[]
    for entry in opt:
      Result={}
      categorydetails={}
      Result['idProduct']=entry[0]
      Result['name']=entry[7]
      Result['calories']=entry[2]
      Result['description']=entry[3]
      Result['price']=entry[8]
      Result['duration']=entry[5]
      Result['discountPoint']=entry[4]
      Result['highlight']=entry[6]
      if entry[9] == 1:
       Result['status']=str(entry[9]).replace("1", "ACTIVE")
      elif entry[9] == 0:
       Result['status']=str(entry[9]).replace("0", "INACTIVE")
      else:
       Result['status']="UNKNOWN"
      Result['imageUrl']=entry[1]
      categorydetails['idCategory']=entry[11]
      categorydetails['name']=entry[13]
      categorydetails['imageUrl']=entry[12]
      if entry[14] == 1:
       categorydetails['status']=str(entry[14]).replace("1", "ACTIVE")
      elif entry[14] == 0:
       categorydetails['status']=str(entry[14]).replace("0", "INACTIVE")
      else:
       categorydetails['status']="UNKNOWN"
      Result['category']=categorydetails
      Results.append(Result)
    products['products']=Results
    #keydata['data']=products
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='Products highlight'
    container['data']=products
    # test1=container
    # print (container)
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    #return jsonify(container)
    cur.close()
    conn.close()

@app.route('/api/v1/category/list')
def categoryList():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT  category.id_category,category.image_url,category.name,category.status FROM category  order by category.id_category asc;')
    opt = cur.fetchall()
    container={}
    products={}
    keydata={}
    Results=[]
    for entry in opt:
      categorylistdetails={}
      categorylistdetails['idCategory']=entry[0]
      categorylistdetails['name']=entry[2]
      categorylistdetails['imageUrl']=entry[1]
      if entry[3] == 1:
       categorylistdetails['status']=str(entry[3]).replace("1", "ACTIVE")
      elif entry[3] == 0:
       categorylistdetails['status']=str(entry[3]).replace("0", "INACTIVE")
      else:
       categorylistdetails['status']="UNKNOWN"
      Results.append(categorylistdetails)
    products['category']=Results
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='Products list'
    container['data']=products
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/product/category/<foodcategory>')
def productCategorybyName(foodcategory):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT  product.id_product,product.image_url,product.calories,product.description,product.discount_point,product.duration,product.highlight,product.name,product.price,product.status,product.id_category,category.id_category,category.image_url,category.name,category.status FROM product JOIN category on product.id_category=category.id_category where category.name=%s;",[foodcategory])
    opt = cur.fetchall()
    container={}
    products={}
    keydata={}
    Results=[]
    for entry in opt:
      Result={}
      categorydetails={}
      Result['idProduct']=entry[0]
      Result['name']=entry[7]
      Result['calories']=entry[2]
      Result['description']=entry[3]
      Result['price']=entry[8]
      Result['duration']=entry[5]
      Result['discountPoint']=entry[4]
      Result['highlight']=entry[6]
      if entry[9] == 1:
       Result['status']=str(entry[9]).replace("1", "ACTIVE")
      elif entry[9] == 0:
       Result['status']=str(entry[9]).replace("0", "INACTIVE")
      else:
       Result['status']="UNKNOWN"
      Result['imageUrl']=entry[1]
      categorydetails['idCategory']=entry[11]
      categorydetails['name']=entry[13]
      categorydetails['imageUrl']=entry[12]
      if entry[14] == 1:
       categorydetails['status']=str(entry[14]).replace("1", "ACTIVE")
      elif entry[14] == 0:
       categorydetails['status']=str(entry[14]).replace("0", "INACTIVE")
      else:
       categorydetails['status']="UNKNOWN"
      Result['category']=categorydetails
      Results.append(Result)
    products['products']=Results
    #keydata['data']=products
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='Products category with name'
    container['data']=products
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    #return jsonify(container)
    cur.close()
    conn.close()

@app.route('/api/v1/user/is-valid-username/<usrname>')
def verifyCustomerName(usrname):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT username from user_app where username=%s;",[usrname])
    opt = cur.fetchone()
    container={}
    products={}
    keydata={}
    Result={}
    if opt == None:
        container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        container['statusCode']='400'
        container['status']='BAD_REQUEST'
        container['message']='The user called does not exist'
    else:
        Result['username']=opt[0]
        # for entry in opt:
        #   Result={}
        #   Result['username']=entry[0]
        products['User']=Result
        container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        container['statusCode']=200
        container['status']='OK'
        container['message']='get username'
        container['data']=products
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()


@app.route('/api/v1/user/is-valid-email/<email>')
def verifyCustomereMail(email):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT email from user_app where email=%s;",[email])
    opt = cur.fetchone()
    container={}
    products={}
    keydata={}
    Result={}
    print (opt)
    if opt == None:
        container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        container['statusCode']='400'
        container['status']='BAD_REQUEST'
        container['message']='The User with mail does not exist'
    else:
        Result['email']=opt[0]
        # for entry in opt:
        #   print (entry[0])
        #   Result['email']=entry[0]
        products['User']=Result
        container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        container['statusCode']=200
        container['status']='OK'
        container['message']='Get user by email'
        container['data']=products
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()


@app.route('/api/v1/login', methods=['POST'])            #####roles   and db check for password and tokens   
def login():
    container={}
    conn = get_db_connection()
    cur = conn.cursor()
    formData = dict(request.form)
    userName = formData["username"]
    userpassword = formData["password"]
    cur.execute("""SELECT username,password,user_roles FROM user_app WHERE username=%s;""",[userName])
    opt = cur.fetchone()
    print (opt)
    print (userName)
    print (userpassword)
    try:
        is_correct_password= check_password_hash(opt[1],userpassword)
    except TypeError:
        print("Something else went wrong")
    if opt != None:
        if is_correct_password == True:
            additional_claims = {"roles": [opt[2]], "iss" : "http://192.168.198.133:8081/api/v1/login"}
            refreshtoken=create_refresh_token(identity=opt[0],additional_claims=additional_claims)
            accesstoken=create_access_token(identity=opt[0])
            tokendict={}
            datadict={}
            resultdict={}
            container['statusCode']=200
            container['status']="OK"
            container['message']="tokens"
            tokendict['valid']=True
            tokendict['access_token']=accesstoken
            if opt[2] == 0:
                    tokendict['userRoles']='ROLE_ADMIN'
            if opt[2] == 1:
                    tokendict['userRoles']='ROLE_EMPLOYEE'
            if opt[2] == 2:
                    tokendict['userRoles']='ROLE_CLIENT'
            tokendict['refresh_token']=refreshtoken
            datadict['tokens']=tokendict
            container['data']=datadict

        if is_correct_password == False:
            container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            container['statusCode']='401'
            container['status']='UnauthorizedT'
            container['path']='/api/v1/login'
            container['message']='User password incorrect'

    elif opt == None:
        container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        container['statusCode']='401'
        container['status']='UnauthorizedT'
        container['path']='/api/v1/login'
        container['message']='The User does not exist'
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()


@app.route('/api/v1/token-refresh', methods=['GET'])              ###cors error correct
@jwt_required(refresh=True)
def tokenrefresh():
    identity = get_jwt_identity()
    access = create_access_token(identity=identity)
    container={}
    tokendict={}
    datadict={}
    resultdict={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="tokens"
    tokendict['valid']=True
    tokendict['access_token']=access
    datadict['tokens']=tokendict
    container['data']=datadict
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
        )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()


# @app.route('/api/v1/user/', methods=['POST'])
# def createUser():
#     container={}
#     conn = get_db_connection()
#     cur = conn.cursor()
#     datadict = request.form['request']
#     formData =  json.loads(datadict)
#     print (formData)
#     print (type(formData))
#     id_User = formData["idUser"]
#     username = formData["username"]
#     name = formData["name"]
#     urlImage = ["urlImage"]
#     phone = formData["phone"]
#     email = formData["email"]
#     password = formData["password"]
#     pwd_hash = generate_password_hash(password)
#     discountPoint = formData["discountPoint"]
#     intuserRoles = formData["userRoles"]
#     userName = formData["username"]
#     userstatus = formData["status"]
#     if userstatus=="ACTIVE":
#         status=1
#     else:
#         status=0
#     if intuserRoles == "ROLE_ADMIN":
#                         userRoles=0
#     elif intuserRoles == "ROLE_EMPLOYEE":
#                         userRoles=1
#     elif intuserRoles == "ROLE_CLIENT":
#                         userRoles=2
#     cur.execute("""INSERT INTO
#         user_app (
#                 id_user,
#                 discount_point,
#                 email,
#                 name,
#                 password,
#                 phone,
#                 status,
#                 user_roles,
#                 username)
#     VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)""", (id_User,discountPoint,email,name,pwd_hash,phone,status,userRoles,username))
#     conn.commit()
#     # opt = cur.fetchone()[0]
#     # print(opt)
#     tokendict={}
#     datadict={}
#     resultdict={}
#     container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#     container['statusCode']=200
#     container['status']="OK"
#     container['message']="Create user"
#     tokendict['idUser']=id_User
#     tokendict['name']=name
#     tokendict['username']=username
#     tokendict['urlImage']=None
#     tokendict['phone']=phone
#     tokendict['email']=email
#     tokendict['password']=pwd_hash
#     tokendict['discountPoint']=discountPoint
#     tokendict['userRoles']=intuserRoles
#     tokendict['status']=userstatus
#     datadict['user']=tokendict
#     container['data']=datadict
#     resreturn=app.response_class(
#     response=json.dumps(container),
#     mimetype='application/json'
#     )
#     resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
#     return resreturn
#     cur.close()
#     conn.close()


@app.route('/api/v1/user/', methods=['POST'])
def createUser():
    container={}
    conn = get_db_connection()
    cur = conn.cursor()
    datadict = request.form['request']
    formData =  json.loads(datadict)
    print (formData)
    print (type(formData))
    username = formData["username"]
    name = formData["name"]
    phone = formData["phone"]
    email = formData["email"]
    password = formData["password"]
    pwd_hash = generate_password_hash(password)
    cur.execute("""INSERT INTO
         user_app (
                 discount_point,
                 email,
                 name,
                 password,
                 phone,
                 status,
                 user_roles,
                 username)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s)""", (0,email,name,pwd_hash,phone,1,2,username))
    conn.commit()
    tokendict={}
    datadict={}
    resultdict={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="Create user"
    tokendict['name']=name
    tokendict['username']=username
    tokendict['phone']=phone
    tokendict['email']=email
    tokendict['password']=pwd_hash
    datadict['user']=tokendict
    container['data']=datadict
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/token-refresh/user', methods=['GET'])              ###cors error correct
@jwt_required(refresh=True)
def tokenrefresuserh():
    identity = get_jwt_identity()
    access = create_access_token(identity=identity)
    current_user = get_jwt_identity()
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""SELECT id_user,discount_point,email,name,phone,status,user_roles,username,url_image FROM user_app WHERE username=%s;""",[current_user])
    opt = cur.fetchone()
    print(opt)
    container={}
    tokendict={}
    datadict={}
    resultdict={}
    newtokendict={}
    userinfodict={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="user login"
    newtokendict['access_token']=access
    userinfodict['idUser']=opt[0]
    userinfodict['name']=opt[3]
    userinfodict['username']=opt[7]
    userinfodict['urlImage']=opt[8]
    userinfodict['phone']=opt[4]
    userinfodict['email']=opt[2]
    userinfodict['discountPoint']=opt[1]
    if opt[6] == 0:
                    userinfodict['userRoles']='ROLE_ADMIN'
    if opt[6] == 1:
                    userinfodict['userRoles']='ROLE_EMPLOYEE'
    if opt[6] == 2:
                    userinfodict['userRoles']='ROLE_CLIENT'
    if opt[5] == 1:
       userinfodict['status']="ACTIVE"
    elif opt[5] == 0:
       userinfodict['status']="INACTIVE"
    else:
       userinfodict['status']="UNKNOWN"
    tokendict['tokens']=newtokendict
    tokendict['user']=userinfodict
    datadict['user']=tokendict
    container['data']=datadict
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
        )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/bill/', methods=['POST'])
def billreceipt():
    conn = get_db_connection()
    cur = conn.cursor()
    json = request.json
    datevar = json["date"]
    noTable = json["noTable"]
    payMode = dict(json["payMode"])
    idPayMode = payMode["idPayMode"]
    user = json["user"]
    idTransaction = json["idTransaction"]
    cur.execute("""INSERT INTO
         user_app (
                date,id_transactionno_table,status_bill ,total_price,id_pay_mode,id_user)
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s)""", (datevar,idTransaction,))
    conn.commit()
    tokendict={}
    datadict={}
    resultdict={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="Create user"
    tokendict['name']=name
    tokendict['username']=username
    tokendict['phone']=phone
    tokendict['email']=email
    tokendict['password']=pwd_hash
    datadict['user']=tokendict
    container['data']=datadict
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/product/', methods=['POST'])
@jwt_required(refresh=True)
def createnewproduct():
    container={}
    conn = get_db_connection()
    cur = conn.cursor()
    datadict = request.form['request']
    formData =  json.loads(datadict)
    idProduct=formData["idProduct"]
    name = formData["name"]
    calories = formData["calories"]
    discription = formData["description"]
    price = formData["price"]
    duration = formData["duration"]
    highlight = formData["highlight"]
    discountPrice = int(formData["discountPoint"])
    status = formData["status"]
    if status=="ACTIVE":
        status=1
    else:
        status=0
    category = formData["category"]
    catdat =  category["idCategory"]
    imageUrl = formData["imageUrl"]
    cur.execute("""INSERT INTO
         product (image_url,calories,description,discount_point,duration,highlight,name,price,status,id_category)
          VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)""", (imageUrl,calories,discription,discountPrice,duration,highlight,name,price,status,catdat))
    conn.commit()
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="Add Prod"
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/category/', methods=['POST'])
@jwt_required(refresh=True)
def createnewcategory():
    container={}
    conn = get_db_connection()
    cur = conn.cursor()
    datadict = request.form['request']
    formData =  json.loads(datadict)
    name=formData["name"]
    status = formData["status"]
    if status=="ACTIVE":
        status=1
    else:
        status=0
    cur.execute("""INSERT INTO
         category (name,status )
          VALUES (%s,%s)""", (name,status))
    conn.commit()
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="Add category"
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/subscriber/<subd>')
def subsName(subd):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""INSERT INTO
         subscriber (email,status )
          VALUES (%s,%s)""", (subd,1))
    conn.commit()
    container={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='email added'
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()


@app.route('/api/v1/product/<prodremove>', methods=['DELETE'])
@jwt_required(refresh=True)
def removeProd(prodremove):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("DELETE from  product where id_product=%s;",[prodremove])
    conn.commit()
    container={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='Item deleted'
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/category/<categoryremove>', methods=['DELETE'])
@jwt_required(refresh=True)
def removeCate(categoryremove):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("DELETE from  category where id_category=%s;",[categoryremove])
    conn.commit()
    container={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='category deleted'
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/user/list/0')
@jwt_required(refresh=True)
def userHighlight():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('select * from user_app where user_roles=2;')
    opt = cur.fetchall()
    container={}
    products={}
    keydata={}
    Results=[]
    for entry in opt:
      Result={}
      categorydetails={}
      Result['idUser']=entry[0]
      Result['name']=entry[3]
      Result['username']=entry[9]
      Result['urlImage']=entry[3]
      Result['phone']=entry[5]
      Result['email']=entry[2]
      Result['discountPoint']=entry[1]
      if opt[8] == 0:
                    Result['userRoles']='ROLE_ADMIN'
      if opt[8] == 1:
                    Result['userRoles']='ROLE_EMPLOYEE'
      if opt[8] == 2:
                    Result['userRoles']='ROLE_CLIENT'      
      if entry[6] == 1:
        Result['status']=str(entry[9]).replace("1", "ACTIVE")
      elif entry[6] == 0:
       Result['status']=str(entry[9]).replace("0", "INACTIVE")
      else:
       Result['status']="UNKNOWN"
      Results.append(Result)
    products['user']=Results
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='List user'
    container['data']=products
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/user/<userremove>', methods=['DELETE'])
@jwt_required(refresh=True)
def removeUser(userremove):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("DELETE from  user_app where id_user=%s;",[userremove])
    conn.commit()
    container={}
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']='OK'
    container['message']='user deleted'
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

@app.route('/api/v1/user/<useredt>', methods=['PUT'])
@jwt_required(refresh=True)
def editUser(useredt):
    container={}
    conn = get_db_connection()
    cur = conn.cursor()
    datadict = request.form['request']
    formData =  json.loads(datadict)
    name=formData["name"]
    phone = formData["phone"]
    email = formData["email"]
    urlImage = formData["urlImage"]
    status = formData["status"]
    if status=="ACTIVE":
        status=1
    else:
        status=0
    username = formData["username"]
    cur.execute("""UPDATE user_app set 
         name=%s,phone=%s,email=%s,url_image=%s,status=%s,username=%s where id_user=%s""", (name,phone,email,urlImage,status,username,useredt))
    conn.commit()
    container['timeStamp']=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    container['statusCode']=200
    container['status']="OK"
    container['message']="Edited user"
    resreturn=app.response_class(
    response=json.dumps(container),
    mimetype='application/json'
    )
    resreturn.headers.add('Access-Control-Allow-Origin', whitelistIP)
    return resreturn
    cur.close()
    conn.close()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port='8080')

