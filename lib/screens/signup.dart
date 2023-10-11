import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_panammun/apis/api.dart';
import 'package:up_panammun/screens/signin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  void initState() {
    // TODO: implement initState
    super.initState();
    print("inicio");
    getAllcomites();
    //getAllpaises();
    getAllschools();
    print(dropdowncomite);
  }

  final _formKey = GlobalKey<FormState>();
 late String name,email, password;
  bool isLoading=false;
  GlobalKey<ScaffoldState>_scaffoldKey=GlobalKey();
 late ScaffoldMessengerState scaffoldMessenger ;
  String? dropdownschools;
  var schools = [];
 /* List <String> schools= [
    'Colegio Esperanza',
    'Colegio Bosques',
    'Colegio Triana',
    'Colegio Encino',
    'Colegio Alpes',
    'Instituto Cumbres',
    'BachUAA',
  ];*/
  String? dropdowncomite;
  var comites = [];
  String? dropdownpais;
  var paises = [];
  /*List <String> paises= [
    'Mexico',
    'Argentina',
    'Brasil',
    'USA',
    'Colombia',
    'Chile',
    'Panamá',
  ];*/
  var reg=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
   Future<File>? file;
  String status = '';
  String base64Image ='';
  File tmpFile = File('');
  String error = 'Error';
  String mensaje = "";
  TextEditingController _nameController=new TextEditingController();
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();

  Future getAllcomites()async{
    var url =COMITES;
    var response = await http.get(url);
    //print("comites");
    //print(response.body);
    if (response.statusCode == 200){
      var jsonData = json.decode(response.body);
      setState((){
        comites = jsonData;
      });
    }
  }

  Future getAllpaises(String? comite)async{
    var url =PAISES;
    Map data = {
      'comite': comite,
    };
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
        encoding: Encoding.getByName("utf-8")
    );
    print("paises");
    print(response.body);
    //print(response.body.substring(0,8)=="nopaises"); tuve que recortar el ultimo caracter que no se cual sea
    if (response.statusCode == 200) {
      print(response.body);
      if (response.body.substring(0,response.body.length-1) != "nopaises") {
        var jsonData = json.decode(response.body);
        print(jsonData);
        setState(() {
        paises = jsonData;
      });
    }
      else {
        setState(() {
          paises = [];
        });
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Este comité ya no tiene países disponibles. Selecciona otro",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.red));
      }
    }
  }
  Future getAllschools()async{
    var url =ESCUELAS;
    var response = await http.get(url);
    //print("escuelas");
    //print(response.body);
    if (response.statusCode == 200){
      var jsonData = json.decode(response.body);
      //print(jsonData);
      setState((){
        schools = jsonData;
      });
    }
  }
  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      key: _scaffoldKey,
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFFF2F2F0)
            ),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.07,
                  ),
                  Center(
                      child: Image.asset(
                    "assets/logo_sinfondo.png",
                    height: MediaQuery.of(context).size.width*0.5,
                    width:  MediaQuery.of(context).size.width*0.5,
                    alignment: Alignment.center,
                  )),
                  Text(
                    "Regístrate",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.06,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      margin:
                      EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width*0.05),
                    child:
                  ListView(
                  children: [
                    Form(
                    key: _formKey,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                            controller: _nameController,

                            decoration: InputDecoration(

                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: "Nombre completo",
                              hintStyle: GoogleFonts.prata(
                                  textStyle:TextStyle(
                                      color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.04)),
                            ),
                            onSaved: (val) {
                              name = val!;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width*0.02,
                          ),
                          TextFormField(
                            style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                            controller: _emailController,

                            decoration: InputDecoration(

                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: "Correo electrónico",
                              hintStyle: GoogleFonts.prata(
                                  textStyle:TextStyle(
                                      color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.04)),
                            ),
                            onSaved: (val) {
                              email = val!;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width*0.02,
                          ),
                          TextFormField(
                            style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: "Contraseña",
                              hintStyle: GoogleFonts.prata(
                                  textStyle:TextStyle(
                                      color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.04)),
                            ),
                            onSaved: (val) {
                              password = val!;
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width*0.02,
                          ),

                          DropdownButton<String>(
                            hint: Text("Selecciona tu escuela de procedencia",style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.04))),
                            isExpanded: true,
                            value: dropdownschools,
                            dropdownColor: Color(0xFFF2B33D),
                            icon: Icon(Icons.arrow_drop_down),
                            iconEnabledColor: Colors.black,
                            iconSize: MediaQuery.of(context).size.width*0.06,
                            elevation: 16,
                            style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                            underline: Container(
                              height: MediaQuery.of(context).size.height*0.002,
                              color: Colors.black,
                            ),
                            onChanged: (String? data) {
                              setState(() {
                                dropdownschools = data.toString();
                                //print(dropdownValue);
                              });
                            },
                            items: schools.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value['escuela'],
                                child: Text(value['escuela'],  style: GoogleFonts.prata(
                                    textStyle:TextStyle(
                                        color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                              );
                            }).toList(),
                          ),
                          DropdownButton<String>(
                            hint: Text("Selecciona un comité",style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.04))),
                            isExpanded: true,
                            value: dropdowncomite,
                            dropdownColor: Color(0xFFF2B33D),
                            icon: Icon(Icons.arrow_drop_down),
                            iconEnabledColor: Colors.black,
                            iconSize: MediaQuery.of(context).size.width*0.06,
                            elevation: 16,
                            style: GoogleFonts.prata(
                              textStyle:TextStyle(
                              color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                            underline: Container(
                              height: MediaQuery.of(context).size.height*0.002,
                              color: Colors.black,
                            ),
                            onChanged: (String? data) {
                              setState(() {
                                dropdowncomite = data.toString();
                                getAllpaises(dropdowncomite);
                                //print(dropdownValue);
                              });
                            },
                            items: comites.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value['comite'],
                                child: Text(value['comite'],  style: GoogleFonts.prata(
                                    textStyle:TextStyle(
                                        color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                              );
                            }).toList(),
                          ),
                          dropdowncomite!=null ? (
                          DropdownButton<String>(
                            hint: Text("Selecciona un país",style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.04))),
                            isExpanded: true,
                            value: dropdownpais,
                            dropdownColor: Color(0xFFF2B33D),
                            icon: Icon(Icons.arrow_drop_down),
                            iconEnabledColor: Colors.black,
                            iconSize: MediaQuery.of(context).size.width*0.06,
                            elevation: 16,
                            style: GoogleFonts.prata(
                                textStyle:TextStyle(
                                    color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                            underline: Container(
                              height: MediaQuery.of(context).size.height*0.002,
                              color: Colors.black,
                            ),
                            onChanged: (String? data) {
                              setState(() {
                                dropdownpais = data.toString();
                                //print(dropdownValue);
                              });
                            },
                            items: paises.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value['pais'],
                                child: Text(value['pais'],  style: GoogleFonts.prata(
                                    textStyle:TextStyle(
                                        color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                              );
                            }).toList(),
                          ))
                          :SizedBox(),
                          FutureBuilder<File>(
                            future: file,
                            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done &&
                                  null != snapshot.data) {
                                tmpFile = snapshot.data!;
                                base64Image = base64Encode(snapshot.data!.readAsBytesSync());
                                return Container(
                                  margin: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.03),
                                  /*child: Material(
                                    elevation: 3.0,
                                    child: Image.file(
                                      snapshot.data!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),*/
                                  child: Material(
                                    elevation: 3.0,
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          child: Image.file(
                                            snapshot.data!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (null != snapshot.error) {
                                return Text(
                                  'Error',  style: GoogleFonts.prata(
                                    textStyle: TextStyle(
                                        color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04)),
                                );
                              } else {
                                return Container(
                                  margin: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.03),
                                  child: Material(
                                    elevation: 3.0,
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          child: Image.asset('assets/placeholder-image.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.03,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.07,
                            width: MediaQuery.of(context).size.width*0.75,
                            child: ElevatedButton(
                              //color: Colors.transparent,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(50)),// Background color
                              ),
                              //shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),
                                //  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                //uploadImg();
                                chooseImage();
                              },
                              child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.cloud_upload_outlined,
                                    color:Colors.black
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.03,
                                ),
                              Text(
                                'Sube tu comprobante de pago',
                                style: GoogleFonts.prata(
                                    textStyle: TextStyle(
                                        color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.035)),
                              ),
                              ],),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),],
                  ),),
                  ),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin:
                        EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.13),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height*0.001, horizontal: 0),
                        height: MediaQuery.of(context).size.height*0.07,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: InkWell(
                          onTap: (){
                            if(isLoading)
                            {
                              return;
                            }
                            if(_nameController.text.isEmpty)
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("Por favor ingresa tu nombre completo",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                  backgroundColor: Colors.red));
                              return;
                            }
                            if(!reg.hasMatch(_emailController.text))
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("Ingresa un correo electrónico válido",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                  backgroundColor: Colors.red));
                              return;
                            }
                            if(_passwordController.text.isEmpty||_passwordController.text.length<6)
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("La contraeña debe tener al menos 6 caracteres",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                  backgroundColor: Colors.red));
                              return;
                            }
                            if(dropdownschools==null)
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("Por favor seleccione una escuela de procedencia",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                  backgroundColor: Colors.red));
                              return;
                            }
                            if(dropdowncomite==null)
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("Por favor seleccione un comité",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                  backgroundColor: Colors.red));
                              return;
                            }
                            if(dropdownpais==null)
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("Por favor seleccione un país",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                  backgroundColor: Colors.red));
                              return;
                            }
                            if(tmpFile == File('') || base64Image == '')
                            {
                              scaffoldMessenger.showSnackBar(SnackBar(content:Text("Suba la imagen de su comprobante de pago",  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                              backgroundColor: Colors.red));
                              return;
                            }
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                              title: Text('Panammun 2023',  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                              content: Text('¿Toda tu información es correcta?, Asegúrate de que toda tu información'
                                  ' sea correcta ya que será evaluada por nuestro comité de registro.',  style: GoogleFonts.prata(
                                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child:  Text('Cancelar',  style: GoogleFonts.prata(
                                      textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'OK'),
                                    signup(_nameController.text,_emailController.text,_passwordController.text,dropdownschools,dropdowncomite,dropdownpais,base64Image,tmpFile.path.split('/').last),
                                    //prueba(),
                                  },
                                  child: Text('Continuar',  style: GoogleFonts.prata(
                                      textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                ),
                              ],
                            ),
                            );
                            //prueba();
                            //signup(_nameController.text,_emailController.text,_passwordController.text,dropdownschools,dropdowncomite,dropdownpais,base64Image,tmpFile.path.split('/').last);
                          },
                          child: Text(
                            "Registrarme",
                            textAlign: TextAlign.center,  style: GoogleFonts.prata(
                              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, letterSpacing: 1)),
                          ),
                        ),
                      ),
                      Positioned(child: (isLoading)?Center(child: Container(height:MediaQuery.of(context).size.width*0.06,width: MediaQuery.of(context).size.width*0.06,child: CircularProgressIndicator(backgroundColor: Color(0xFF3B52D9),))):Container(),right: MediaQuery.of(context).size.width*0.2,bottom: 0,top: 0,)

                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new SignIn(),
                        ),
                      );
                    },
                    child: Text(
                      "Si ya tienes una cuenta, da click aquí",  style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, letterSpacing: 1,decoration: TextDecoration.underline)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
   prueba () async{
    setState(() {
      isLoading=true;
    });
  print("Calling");
    mensaje = "Hola, prueba";
    final responsemail = await sendEmail("Luis","lfcornelas@gmail.com","mensaje");
    print(responsemail);
    if (responsemail == 200)
      print("Correo enviado exitosamente");
    else
      print("Fallo en enviar correo");
}
  signup(name,email,password,school,comite,pais,imagen,nameimage) async
  {
    setState(() {
      isLoading=true;
    });
    print("Calling");

    Map data = {
      'email': email,
      'password': password,
      'name': name,
      'escuela': school,
      'comite': comite,
      'pais': pais,
      'imagen':imagen,
      'nameimg':nameimage
    };
    print(data.toString());
    final  response= await http.post(
      Uri.parse(REGISTRATION),
        //Uri.parse("https://panammun-production.up.railway.app/registration.php"),
        headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },


      body: data,
        encoding: Encoding.getByName("utf-8")
    )  ;
    print(response.statusCode);
    if (response.statusCode == 200) {

      setState(() {
        isLoading=false;
      });
      print(response.body);
      Map<String,dynamic>resposne=jsonDecode(response.body);
      if(!resposne['error'])
        {
          Map<String,dynamic>user=resposne['data'];
          print(" User name ${user['name']}");
          mensaje = "Nombre: " + user['name']+"\n"+"Correo: " + user['email']+"\n"+"Escuela: " + user['escuela']+"\n"+"Comité: "+user['comite']+"\n"+"País: "+user['pais'];
          final responsemail = await sendEmail(user['name'],user['email'],mensaje);
          print(responsemail);
          if (responsemail == 200)
            _showDialog1(context);
            //print("Correo enviado exitosamente");
          else
            _showDialog2(context);
            //print("Fallo en enviar correo");

          scaffoldMessenger.showSnackBar(SnackBar(content:Text("${resposne['message']}",  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
              backgroundColor: Colors.green));
          savePref(1,user['name'],user['email'],user['id'],user['escuela'],user['comite'],user['pais'], user['estatus']);
          //ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new Home(),
            ),
          );

        }else{
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("${resposne['message']}",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.red));
      }
    } else {
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Porfavor intenta de nuevo",  style: GoogleFonts.prata(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
  backgroundColor: Colors.red));
    }

  }

  savePref(int value, String name, String email, int id, String escuela, String comite, String pais, int status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //print("entrando");
    //print(status);
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("id", id.toString());
    preferences.setString("escuela", escuela);
    preferences.setString("comite", comite);
    preferences.setString("pais", pais);
    preferences.setInt("estatus", status);
    //print("saliendo");
      preferences.commit();
  }

  Future sendEmail(String name, String email, String message) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_lwwya67';
    const templateId = 'template_yye1vza';
    const userId = 'kMACX9DZytiSClMxs';
    try {
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json'},
          //This line makes sure it works for all platforms.
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'from_name': name,
              'from_email': email,
              'message': message
            }
          }));
      //print("entrando a correo3");
      return response.statusCode;
    } catch (error){
      print('[SEND FEEDBACK MAIL ERROR]');
    }
    setState(() {
      isLoading=false;
    });
  }

  void _showDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Panammun 2023",  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          content: new Text("Correo enviado exitosamente",  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          actions: <Widget>[
            new TextButton(
              child: new Text("Entendido",  style: GoogleFonts.prata(
                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Panammun 2023",  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          content: new Text("Error al enviar correo",  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          actions: <Widget>[
            new TextButton(
              child: new Text("Entendido",  style: GoogleFonts.prata(
                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
