import 'dart:convert';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_panammun/apis/api.dart';
import 'package:up_panammun/screens/signup.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:up_panammun/screens/webdrive.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  bool isLoading=false;
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();
  GlobalKey<ScaffoldState>_scaffoldKey=GlobalKey();
  late ScaffoldMessengerState scaffoldMessenger ;
  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF2F2F0),
            child: Stack(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    color: Color(0xFFF2F2F0)
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                            "assets/logo_sinfondo.png",
                            height: MediaQuery.of(context).size.width*0.4,
                            width: MediaQuery.of(context).size.width*0.4,
                            alignment: Alignment.center,
                          )),
                      Text(
                        "Bienvenido",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.prata(
                          textStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: MediaQuery.of(context).size.width*0.06,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin:
                          EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0, horizontal: MediaQuery.of(context).size.width*0.08),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: GoogleFonts.prata(
                                    textStyle:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width*0.04,
                                      color: Colors.black,
                                    )),
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
                                height: MediaQuery.of(context).size.height*0.01,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
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
                                  email = val!;
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.03,
                              ),
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if(isLoading)
                                      {
                                        return;
                                      }
                                      if(_emailController.text.isEmpty||_passwordController.text.isEmpty)
                                      {
                                        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Porfavor llena todos los campos",  style: GoogleFonts.prata(
                                            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                            backgroundColor: Color(0xFF023859)));
                                        return;
                                      }
                                      login(_emailController.text,_passwordController.text);
                                      setState(() {
                                        isLoading=true;
                                      });
                                      //Navigator.pushReplacementNamed(context, "/home");
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context).size.width*0.01, horizontal: 0),
                                      height: MediaQuery.of(context).size.height*0.06,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        "Ingresar",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.prata(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context).size.width*0.04,
                                                letterSpacing: 1)),
                                      ),
                                    ),
                                  ),
                                  Positioned(child: (isLoading)?Center(child: Container(height:MediaQuery.of(context).size.width*0.06,width: MediaQuery.of(context).size.width*0.06,child: CircularProgressIndicator(backgroundColor: Color(0xFF3B52D9),))):Container(),right: MediaQuery.of(context).size.width*0.05,bottom: 0,top: 0,)

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("tap");
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Regístrate",
                          style: GoogleFonts.prata(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width*0.04,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0.5)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDialog2(context,"Documentos Panammun", "Documentos Panammun",
                              "https://drive.google.com/file/d/1CIDyEVKQKUjuhv07DYIdVu_A-Cul3Mew/view?usp=sharing",
                              "https://drive.google.com/file/d/1L1DKhmbA6MhMUCsGVqSOVqib5_5NO27l/view?usp=sharing",
                              "https://drive.google.com/file/d/1m7qJtKg1ELjT6rF06q5mXTKvI5FMsj0n/view?usp=sharing",
                              "https://drive.google.com/file/d/1pxsHJkyIzzbQue1k3TVnpR1jhyNXmM0u/view?usp=sharing");
                        },
                        child: Text(
                          "Documentos",
                          style: GoogleFonts.prata(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width*0.04,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0.5)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.02,
                      ),
                      /*(
                    onTap: () {
                      //Navigator.pushReplacementNamed(context, "/webinfo");
                    },
                    child: Text(
                      "COMITÉS",
                      style: GoogleFonts.prata(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.04,
                              //decoration: TextDecoration.underline,
                              letterSpacing: 0.5)),
                    ),
                  ),*/
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"ASAMBLEA GENERAL", "La Asamblea General es el órgano principal de las Naciones Unidas de "
                                  "deliberación, adopción de políticas y representación. Está integrada por los 193"
                                  "Estados Miembros de las Naciones Unidas y constituye un foro singular para las"
                                  "deliberaciones multilaterales sobre toda la gama de cuestiones internacionales"
                                  "que abarca la Carta de las Naciones Unidas. En dicho órgano existe igualdad de"
                                  "voto para todos los Estados Miembros.",
                                  "https://drive.google.com/file/d/1zO0bEo37bggIPu1neFx8lgLsDV2PgonW/view?usp=sharing",
                                  "https://drive.google.com/file/d/1TQsGBiXrviuqTET98mGE7C75pUXmvVJF/view?usp=sharing");
                            },
                            icon: Image.asset("assets/asambleageneral.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                            //cart+ icon from FontAwesome
                          ),
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"ECOSOC", "El Consejo Económico y Social forma parte del núcleo del sistema de las Naciones Unidas y tiene como objetivo promover la materialización de las tres dimensiones del desarrollo sostenible (económica, social y ambiental). Este órgano constituye una plataforma fundamental para fomentar el debate y el pensamiento innovador, alcanzar un consenso sobre la forma de avanzar y coordinar los esfuerzos encaminados al logro de los objetivos convenidos internacionalmente. Asimismo, es responsable del seguimiento de los resultados de las grandes conferencias y cumbres de las Naciones Unidas.",
                                  "https://drive.google.com/file/d/1N-RfuajcXF1jpDO8dMepexO7Qz2-4XQz/view?usp=sharing",
                                  "https://drive.google.com/file/d/1FwJK69WQ5c_FVW0E1MYGCyf39wz2Uhy9/view?usp=sharing");
                            },
                            icon: Image.asset("assets/ecosoc.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                          ),
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"DERECHOS HUMANOS", "El Comité de Derechos Humanos es el órgano de expertos independientes que supervisa la aplicación del Pacto Internacional de Derechos Civiles y Políticos por sus Estados Partes.Todos los Estados Partes deben presentar al Comité informes periódicos sobre la manera en que se ejercitan los derechos. Inicialmente los Estados deben presentar un informe un año después de su adhesión al Pacto y luego siempre que el Comité lo solicite (por lo general cada cuatro años). El Comité examina cada informe y expresa sus preocupaciones y recomendaciones al Estado Parte en forma de \"observaciones finales\".",
                                  "https://drive.google.com/file/d/11LYgWnyingBLKuwuWTZPLcCAe8VY9Di8/view?usp=sharing",
                                  "https://drive.google.com/file/d/1rh3J_6uCXS0w3fvOfoxvR9MceI96KHW7/view?usp=sharing");
                            },
                            icon: Image.asset("assets/hrc.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                          ),
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"OEA", "La Organización de los Estados Americanos es el organismo regional más antiguo del mundo, cuyo origen se remonta a la Primera Conferencia Internacional Americana, celebrada en Washington, D.C., de octubre de 1889 a abril de 1890.  En esta reunión, se acordó crear la Unión Internacional de Repúblicas Americanas y se empezó a tejer una red de disposiciones e instituciones que llegaría a conocerse como “sistema interamericano”, el más antiguo sistema institucional internacional.",
                                  "https://drive.google.com/file/d/1kw8OB6g5s2BoH5KFj1Op4uSwBcbnnOCY/view?usp=sharing",
                                  "https://drive.google.com/file/d/1Sz7L_OpMR-UQ8hUKq-gIwrXUiC5fhNM7/view?usp=sharing");
                            },
                            icon: Image.asset("assets/oea.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                          ),
                        ],
                      ),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"UNICEF", "El Fondo de las Naciones Unidas para la Infancia (UNICEF) es la agencia de las Organización de las Naciones Unidas (ONU) enfocada en promover los derechos y el bienestar"
                                  "de todos los niños, niñas y adolescentes en México y en el mundo."
                                  "Fue creado para brindar ayuda urgente a los niños y niñas víctimas de las guerras y abordar"
                                  "las necesidades a largo plazo de la niñez y las mujeres en países en desarrollo que se encuentran en desventaja."
                                  "Actualmente trabaja en 190 países y territorios en acciones prácticas que beneficien a todos los niños, niñas y "
                                  "adolescentes, especialmente los más vulnerables y excluidos.",
                                  "https://drive.google.com/file/d/1sFpcInhaRDSDInkIFGmAa5wzOnrzDH05/view?usp=sharing",
                                  "https://drive.google.com/file/d/1xf43gAa5g8oeBdSFL70_COUOV45EAEPC/view?usp=sharing");
                            },
                            icon: Image.asset("assets/oms.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                          ),
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"ONU MUJERES", "La Comisión de la Condición Jurídica y Social de la Mujer es el principal órgano internacional intergubernamental dedicado exclusivamente a la promoción de la igualdad de género y el empoderamiento de la mujer. Se trata de una comisión orgánica dependiente del Consejo Económico y Social, creado en virtud de la resolución 11 del Consejo, el 21 de junio de 1946.",
                                  "https://drive.google.com/file/d/1njk1AoYstspW9yL90B_0yT4-I_k_kXqR/view?usp=sharing",
                                  "https://drive.google.com/file/d/1vSb59vtk12eVkrzdskKJJLdnKBXLGiXA/view?usp=sharing");
                            },
                            icon: Image.asset("assets/onumujeres.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                          ),
                          IconButton(
                            onPressed: (){
                              _showDialog1(context,"SECURITY COUNCIL", "El Consejo de Seguridad tiene la responsabilidad primordial del mantenimiento de la paz y la seguridad internacionales. Tiene 15 Miembros, y cada Miembro tiene un voto. Según la Carta de las Naciones Unidas, todos los Estados miembros están obligados a cumplir las decisiones del Consejo.",
                                  "https://drive.google.com/file/d/1ayLRb8oGmFxQTWVL9nxVqBMf-mUXBujk/view?usp=sharing",
                                  "https://drive.google.com/file/d/1odvM3zkcukEM6upFjdmMPSJV5VF-ag_v/view?usp=sharing");
                            },
                            icon: Image.asset("assets/securitycouncil.png"),
                            iconSize: MediaQuery.of(context).size.width*0.15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showDialog1(BuildContext context, String comite, String mensaje, String topic1, String topic2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(comite,textAlign: TextAlign.justify,  style: GoogleFonts.prata(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          content: /*new Text(mensaje,  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),*/
          Column(
            children: <Widget>[
              Container(
                  child: new Text(mensaje,textAlign: TextAlign.justify,  style: GoogleFonts.prata(
                      textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1)))),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.01,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.01,
              ),
              Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new WebDrive(url:topic1),
                      ),
                    ),
                    child: Text("Para ver el tópico 1 del comité da click aquí",textAlign: TextAlign.justify,  style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1,
                            decoration:TextDecoration.underline))),
                  )),
              Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new WebDrive(url:topic2),
                      ),
                    ),
                    child: Text("Para ver el tópico 2 del comité da click aquí",textAlign: TextAlign.justify,  style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1,
                            decoration:TextDecoration.underline))),
                  ))
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("Cerrar", textAlign: TextAlign.justify,  style: GoogleFonts.prata(
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
  void _showDialog2(BuildContext context, String titulo, String mensaje, String link1, String link2, String link3, String link4) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(titulo,textAlign: TextAlign.justify,  style: GoogleFonts.prata(
              textStyle: TextStyle(fontWeight:FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          content: /*new Text(mensaje,  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),*/
          Column(
            children: <Widget>[
              Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new WebDrive(url:link1),
                      ),
                    ),
                    child: Text("Reglamento general", textAlign: TextAlign.left, style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1,
                            decoration:TextDecoration.underline))),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.01,
              ),
              Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new WebDrive(url:link2),
                      ),
                    ),
                    child: Text("Reglamento de pajes",textAlign: TextAlign.left,  style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1,
                            decoration:TextDecoration.underline))),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.01,
              ),
              Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new WebDrive(url:link3),
                      ),
                    ),
                    child: Text("Protocolo manual",textAlign: TextAlign.left,  style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1,
                            decoration:TextDecoration.underline))),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.01,
              ),
              Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new WebDrive(url:link4),
                      ),
                    ),
                    child: Text("Circulares", textAlign: TextAlign.justify, style: GoogleFonts.prata(
                        textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1,
                            decoration:TextDecoration.underline))),
                  )),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("Cerrar", textAlign: TextAlign.justify,  style: GoogleFonts.prata(
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
  login(email,password) async
  {

    Map data = {
      "email": email,
      "password": password
    };
    print(data.toString());
    final  response= await http.post(
        Uri.parse(LOGIN),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },


        body: data,
        encoding: Encoding.getByName("utf-8")
    )  ;
    setState(() {
      isLoading=false;
    });
    //print("a");
    //print (response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String,dynamic>resposne=json.decode(response.body);
      if(!resposne['error'])
      {
        Map<String,dynamic>user=resposne['data'];
        print(" User name ${user['name']}");
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("${resposne['message']}",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.green));
        savePref(1,user['name'],user['email'],user['id'],user['escuela'],user['comite'],user['pais'],user['estatus']);
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new Home(),
          ),
        );
      }else{
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Usuario y/o contraseña inválido",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.red));
        print(" ${resposne['message']}");
      }
    } else {
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Porfavor intenta de nuevo",  style: GoogleFonts.prata(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          backgroundColor: Colors.red));
    }

  }

  savePref(int value, String name, String email, int id, String escuela, String comite, String pais, int status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("value", value);
    preferences.setString("name", name);
    preferences.setString("email", email);
    preferences.setString("id", id.toString());
    preferences.setString("escuela", escuela);
    preferences.setString("comite", comite);
    preferences.setString("pais", pais);
    preferences.setInt("estatus", status);
    preferences.commit();

  }
}

