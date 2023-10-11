import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:up_panammun/screens/signin.dart';
import 'package:up_panammun/apis/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(
      home: new Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey webViewKey = GlobalKey();
  bool isLoading2=false;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress3 = 0;
  final urlController = TextEditingController();
  var estadocontainershoras=0;
  var estadocontainersminutos=0;
  var estadocontainerssegundos=0;
  late ScaffoldMessengerState scaffoldMessenger ;
  void initState() {

    // TODO: implement initState
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    //recarga("mhernadez@gmail.com");
    getPref();
    reset();
  }
  String pathPDF = "";
  String pathPDF2 = "";
  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> fromAsset2(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> createFileOfPdfUrl(String url, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> createFileOfPdfUrl2(String url, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();
    print("Start download file from internet2!");
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files2");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file2!');
    }

    return completer.future;
  }

  bool isLoading=false;
  String? nameuser = "";
  String? statustring ="";
  String? colegio ="";
  String? pais ="";
  String? comite ="";
  String? email = "";
  int? estatus = 0;
  int _currentIndex = 0;
  String? dropdowncategoria;
  var nominaciones = [];
  String? dropdownpais;
  var paises = [];

  //upload file
  File? selectedfile;
  File? selectedfile2;
  Response? response;
  String? progress;
  String? progress2;
  Dio dio = new Dio();
  //stopwatchtimer
  static const countdownDuration = Duration(minutes: 15);
  Duration duration = Duration();
  Timer? timer;
  bool countDown =true;


  Future getAllpaises(String? comite)async{
    var url =PAISESVOTACION;
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
    );
    //print(response.body);
    if (response.statusCode == 200){
      var jsonData = json.decode(response.body);
      //print(jsonData);
      setState((){
        paises = jsonData;
      });
    }
    print("paises");
    print(comite);
    print(paises);
  }

  Future getAllnominaciones(String? nameuser)async{
    var url =NOMINACIONES;
    Map data = {
      'user': nameuser,
    };
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
    );
    //print(response.body);
    if (response.statusCode == 200){
      var jsonData = json.decode(response.body);
      //print(jsonData);
      setState((){
        nominaciones = jsonData;
      });
    }
    print("nominaciones");
    print(nameuser);
    print(nominaciones);
  }

  Future insertvote(String? pais,String? categoria,String? comite, String? email, BuildContext context)async{
    var url =VOTACIONES;
    Map data = {
      'categoria': categoria,
      'pais': pais,
      'comite': comite,
      'user': email
    };
    //print(data);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
    );
    //print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200){
      Map<String,dynamic>resposne=jsonDecode(response.body);
      if (resposne['message'] =="Actualizacion correcta")
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Voto registrado exitosamente",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.green));
      else
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Error al votar",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.red));
    }
  }

  selectFile() async {
    selectedfile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    //for file_pocker plugin version 2 or 2+
    /*
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    } */

    setState((){}); //update the UI so that file name is shown
  }

  uploadFile(BuildContext context) async {
    String uploadurl = PDFURL;
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          selectedfile!.path,
          filename: basename(selectedfile!.path)
        //show only filename from path
      ),
      "nameuser": nameuser
    });

    response = await dio.post(uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes de " "$total Bytes - " +  percentage + " % subido";
          //update the progress
        });
      },);
    print(response.toString());
    if(response!.statusCode == 200){
      print(response.toString());
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Archivo subido exitosamente",  style: GoogleFonts.prata(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          backgroundColor: Colors.green));
      //print response from server
    }else{
      print("Error during connection to server.");
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Error al subir archivo", style: GoogleFonts.prata(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1)),),
          backgroundColor: Colors.red));
    }
  }

  selectFile2() async {
    selectedfile2 = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    //for file_pocker plugin version 2 or 2+
    /*
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    } */

    setState((){}); //update the UI so that file name is shown
  }

  uploadFile2(BuildContext context) async {
    String uploadurl2 = PDFURL2;
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata2 = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          selectedfile2!.path,
          filename: basename(selectedfile2!.path)
        //show only filename from path
      ),
      "nameuser": nameuser
    });

    response = await dio.post(uploadurl2,
      data: formdata2,
      onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress2 = "$sent" + " Bytes de " "$total Bytes - " +  percentage + " % subido";
          //update the progress
        });
      },);
    print(response.toString());
    if(response!.statusCode == 200){
      print(response.toString());
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Archivo subido exitosamente",  style: GoogleFonts.prata(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          backgroundColor: Colors.green));
      //print response from server
    }else{
      print("Error during connection to server.");
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Error al subir archivo",  style: GoogleFonts.prata(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          backgroundColor: Colors.red));
    }
  }

  // Function
  Widget comiteinformation(BuildContext context) {
    Widget widget;
    switch (comite) {
      case 'Asamblea General':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height:  MediaQuery.of(context).size.height*0.03),
              Center(
                  child: Image.asset(
                    "assets/asambleageneral.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "La Asamblea General es el órgano principal de las Naciones Unidas de deliberación, adopción de políticas y representación. Está integrada por los 193 Estados Miembros de las Naciones Unidas y constituye un foro singular para el debate multilateral sobre toda la gama de cuestiones internacionales que abarca la Carta de las Naciones Unidas. En dicho órgano existe igualdad de voto para todos los Estados Miembros.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: MediaQuery.of(context).size.width*0.04,
                  ),
                ),
              ),
            ]);
        break;
      case 'Security Council':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Center(
                  child: Image.asset(
                    "assets/securitycouncil.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "El Consejo de Seguridad tiene la responsabilidad primordial del mantenimiento de la paz y la seguridad internacionales. Tiene 15 Miembros, y cada Miembro tiene un voto. Según la Carta de las Naciones Unidas, todos los Estados miembros están obligados a cumplir las decisiones del Consejo.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                  ),
                ),
              ),
            ]);
        break;
      case 'ECOSOC':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Center(
                  child: Image.asset(
                    "assets/ecosoc.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "El Consejo Económico y Social forma parte del núcleo del sistema de las Naciones Unidas y tiene como objetivo promover la materialización de las tres dimensiones del desarrollo sostenible (económica, social y ambiental). Este órgano constituye una plataforma fundamental para fomentar el debate y el pensamiento innovador, alcanzar un consenso sobre la forma de avanzar y coordinar los esfuerzos encaminados al logro de los objetivos convenidos internacionalmente.Asimismo, es responsable del seguimiento de los resultados de las grandes conferencias y cumbres de las Naciones Unidas.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                  ),
                ),
              ),
            ]);
        break;
      case 'ONU Mujeres':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Center(
                  child: Image.asset(
                    "assets/onumujeres.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "La Comisión de la Condición Jurídica y Social de la Mujer es el principal órgano internacional intergubernamental dedicado exclusivamente a la promoción de la igualdad de género y el empoderamiento de la mujer. Se trata de una comisión orgánica dependiente del Consejo Económico y Social, creado en virtud de la resolución 11 del Consejo, el 21 de junio de 1946. La Comisión de la Condición Jurídica y Social de la Mujer desempeña una labor crucial en la promoción de los derechos de la mujer documentando la realidad que viven las mujeres en todo el mundo, elaborando normas internacionales en materia de igualdad de género y empoderamiento de las mujeres. ",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ]);
        break;
      case 'Derechos Humanos':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Center(
                  child: Image.asset(
                    "assets/hrc.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "El Comité de Derechos Humanos es el órgano de expertos independientes que supervisa la aplicación del Pacto Internacional de Derechos Civiles y Políticos por sus Estados Partes.Todos los Estados Partes deben presentar al Comité informes periódicos sobre la manera en que se ejercitan los derechos. Inicialmente los Estados deben presentar un informe un año después de su adhesión al Pacto y luego siempre que el Comité lo solicite (por lo general cada cuatro años). El Comité examina cada informe y expresa sus preocupaciones y recomendaciones al Estado Parte en forma de \"observaciones finales\".",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                  ),
                ),
              ),
            ]);
        break;
      case 'UNICEF':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Center(
                  child: Image.asset(
                    "assets/oms.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "El Fondo de las Naciones Unidas para la Infancia (UNICEF) es la agencia de las Organización de las Naciones Unidas (ONU) enfocada en promover los derechos y el bienestar"
                "de todos los niños, niñas y adolescentes en México y en el mundo."
                "Fue creado para brindar ayuda urgente a los niños y niñas víctimas de las guerras y abordar"
                "las necesidades a largo plazo de la niñez y las mujeres en países en desarrollo que se encuentran en desventaja."
                "Actualmente trabaja en 190 países y territorios en acciones prácticas que beneficien a todos los niños, niñas y "
                "adolescentes, especialmente los más vulnerables y excluidos.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                  ),
                ),
              ),
            ]);
        break;
      case 'OEA':
        widget = Column(
            children:<Widget>[
              Text(
                comite.toString(),
                style: GoogleFonts.prata(
                    textStyle: TextStyle(
                      fontSize:  MediaQuery.of(context).size.width*0.05,
                      color:Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Center(
                  child: Image.asset(
                    "assets/oea.png",
                    height: MediaQuery.of(context).size.width*0.3,
                    width: MediaQuery.of(context).size.width*0.3,
                    alignment: Alignment.center,
                  )),
              SizedBox( height: MediaQuery.of(context).size.height*0.04),
              Text(
                "La Organización de los Estados Americanos es el organismo regional más antiguo del mundo, cuyo origen se remonta a la Primera Conferencia Internacional Americana, celebrada en Washington, D.C., de octubre de 1889 a abril de 1890.  En esta reunión, se acordó crear la Unión Internacional de Repúblicas Americanas y se empezó a tejer una red de disposiciones e instituciones que llegaría a conocerse como “sistema interamericano”, el más antiguo sistema institucional internacional.La Organización fue fundada con el objetivo de lograr en sus Estados Miembros, como lo estipula el Artículo 1 de la Carta, un orden de paz y de justicia, fomentar su solidaridad, robustecer su colaboración y defender su soberanía, su integridad territorial y su independencia.Hoy en día, la OEA reúne a los 35 Estados independientes de las Américas y constituye el principal foro gubernamental político, jurídico y social del Hemisferio. Además, ha otorgado el estatus de Observador Permanente a 69 Estados, así como a la Unión Europea (UE).Para lograr sus más importantes propósitos, la OEA se basa en sus principales pilares que son la democracia, los derechos humanos, la seguridad y el desarrollo.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.prata(
                  textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize:  MediaQuery.of(context).size.width*0.04,
                  ),
                ),
              ),
            ]);
        break;
      default:
        widget = Container();
    }

    // Finally returning a Widget
    return widget;
  }

  openpdf(){
    switch (comite){

      //remote files
      case 'Asamblea General':
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/AG1.pdf', 'AG1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/AG2.pdf', 'AG2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'Security Council':
        print("entre");
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/SC1.pdf', 'SC1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/SC2.pdf', 'SC2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'ECOSOC':
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/ECOSOC1.pdf', 'ECOSOC1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/ECOSOC2.pdf', 'ECOSOC2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'ONU Mujeres':
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/ONUM1.pdf', 'ONUM1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/ONUM2.pdf', 'ONUM2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'Derechos Humanos':
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/HRC1.pdf', 'HRC1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/HRC2.pdf', 'HRC2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'UNICEF':
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/UNICEF1.pdf', 'UNICEF1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/UNICEF2.pdf', 'UNICEF2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'OEA':
        createFileOfPdfUrl('https://uppanammun.s3.amazonaws.com/Documentos/OEA1.pdf', 'OEA1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        createFileOfPdfUrl2('https://uppanammun.s3.amazonaws.com/Documentos/OEA2.pdf', 'OEA2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;

      //local files
    /*
      case 'Asamblea General':
        fromAsset('assets/AG1.pdf', 'AG1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/AG2.pdf', 'AG2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'Security Council':
        print("entre");
        fromAsset('assets/SC1.pdf', 'SC1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/SC2.pdf', 'SC2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'ECOSOC':
        fromAsset('assets/ECOSOC1.pdf', 'ECOSOC1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/ECOSOC2.pdf', 'ECOSOC2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'ONU Mujeres':
        fromAsset('assets/ONUM1.pdf', 'ONUM1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/ONUM2.pdf', 'ONUM2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'Derechos Humanos':
        fromAsset('assets/HRC1.pdf', 'HRC1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/HRC2.pdf', 'HRC2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'OMS':
        fromAsset('assets/OMS1.pdf', 'OMS1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/OMS2.pdf', 'OMS2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;
      case 'OEA':
        fromAsset('assets/OEA1.pdf', 'OEA1.pdf').then((f) {
          setState(() {
            pathPDF = f.path;
          });
        });
        fromAsset2('assets/OEA2.pdf', 'OEA2.pdf').then((f) {
          setState(() {
            pathPDF2 = f.path;
          });
        });
        break;

     */
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    final List _children = [Page1(email:email, nameuser: nameuser, statustring: statustring, colegio: colegio, pais: pais, comite: comite),
      //MI COMITE
      Scaffold(
          body: Stack(
            children:<Widget>[
              Container(
                //alignment: Alignment.center,
                //padding: EdgeInsets.all(40),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color(0xFFF2F2F0),
                /*child: Image.asset(
    "assets/background.jpg",
    fit: BoxFit.fill,
    ),*/
              ),
              Container(
                  margin: EdgeInsets.all(30),
                  child:
                  SingleChildScrollView(
                      child:Column(children: <Widget>[
                        comiteinformation(context),
                        ElevatedButton.icon(
                          onPressed: (){
                            openpdf();
                            print(pathPDF.toString());
                            //print(comite);
                            if (pathPDF.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFScreen(path: pathPDF),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.folder_open),
                          label: Text("Ver tópico 1",style: GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF023859), // Background color
                          ),
                          //color: Color(0xFF023859),
                          //colorBrightness: Brightness.dark,
                        ),
                        ElevatedButton.icon(
                          onPressed: (){
                            openpdf();
                            //print(pathPDF.toString());
                            //print(comite);
                            if (pathPDF2.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFScreen(path: pathPDF2),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.folder_open),
                          label: Text("Ver tópico 2",style: GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF023859), // Background color
                          ),
                          //color: Color(0xFF023859),
                          //colorBrightness: Brightness.dark,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          //show file name here
                          child:progress == null?
                          Text("Progreso: 0%",style: GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))):
                          Text(basename("Progreso: $progress"),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.prata(
                                  textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                          //show progress status here
                        ),

                        Container(
                          margin: EdgeInsets.all(10),
                          //show file name here
                          child:selectedfile == null?
                          Text("Seleccionar archivo de tópico 1",style: GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))):
                          Text(basename(selectedfile!.path),style: GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                          //basename is from path package, to get filename from path
                          //check if file is selected, if yes then show file name
                        ),

                        Container(
                            child:ElevatedButton.icon(
                              onPressed: (){
                                selectFile();
                              },
                              icon: Icon(Icons.folder_open),
                              label: Text("Seleccionar archivo de tópico 1",style: GoogleFonts.prata(
                                  textStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF023859), // Background color
                              ),
                              //color: Color(0xFF023859),
                              //colorBrightness: Brightness.dark,
                            )
                        ),

                        //if selectedfile is null then show empty container
                        //if file is selected then show upload button
                        selectedfile == null?
                        Container():
                        Container(
                            child:ElevatedButton.icon(
                              onPressed: (){
                                uploadFile(context);
                              },
                              icon: Icon(Icons.folder_open),
                              label: Text("Subir archivo de tópico 1",style: GoogleFonts.prata(
                                  textStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF023859), // Background color
                              ),
                              //color: Color(0xFF023859),
                              //colorBrightness: Brightness.dark,
                            )
                        ),

                        Container(
                          margin: EdgeInsets.all(10),
                          //show file name here
                          child:progress2 == null?
                          Text("Progreso: 0%",style:GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))):
                          Text(basename("Progreso: $progress2"),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.prata(
                                  textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                          //show progress status here
                        ),

                        Container(
                          margin: EdgeInsets.all(10),
                          //show file name here
                          child:selectedfile2 == null?
                          Text("Seleccionar archivo de tópico 2",style: GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))):
                          Text(basename(selectedfile2!.path),style:GoogleFonts.prata(
                              textStyle: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                          //basename is from path package, to get filename from path
                          //check if file is selected, if yes then show file name
                        ),

                        Container(
                            child:ElevatedButton.icon(
                              onPressed: (){
                                selectFile2();
                              },
                              icon: Icon(Icons.folder_open),
                              label: Text("Seleccionar archivo de tópico 2",style: GoogleFonts.prata(
                                  textStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF023859), // Background color
                              ),
                              //color: Color(0xFF023859),
                              //colorBrightness: Brightness.dark,
                            )
                        ),

                        //if selectedfile is null then show empty container
                        //if file is selected then show upload button
                        selectedfile2 == null?
                        Container():
                        Container(
                            child:ElevatedButton.icon(
                              onPressed: (){
                                uploadFile2(context);
                              },
                              icon: Icon(Icons.folder_open),
                              label: Text("Subir archivo de tópico 2",style:GoogleFonts.prata(
                                  textStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF023859), // Background color
                              ),
                              //color: Color(0xFF023859),
                              //colorBrightness: Brightness.dark,
                            )
                        )
                      ],)))
            ],)
      ),
      //VENTANA CRONÓMETRO
      Scaffold(
        body: Stack(
          children:<Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFFF2F2F0),
              /*child: Image.asset(
    "assets/background.jpg",
    fit: BoxFit.fill,
    ),*/
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTime(context),
                SizedBox(height: MediaQuery.of(context).size.height*0.04),
                buildButtons(context)
              ],
            ),
          ],
        ),
      ),
      //VISTA NOMINACIONES
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFFF2F2F0),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.1, 0, MediaQuery.of(context).size.width*0.1, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Image.asset(
                        "assets/award.png",
                        height: MediaQuery.of(context).size.width*0.5,
                        width: MediaQuery.of(context).size.width*0.5,
                        alignment: Alignment.center,
                      )),

                  Text(
                    "Nominaciones",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.05,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child:
                      ListView(
                          children: [
                            Container(
                              child: Column(
                                children: <Widget> [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width*0.06,
                                  ),
                                  DropdownButton<String>(
                                    hint: Text("Selecciona una categoria de votación",style: GoogleFonts.prata(
                                        textStyle:
                                        TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                                    isExpanded: true,
                                    value: dropdowncategoria,
                                    dropdownColor: Color(0xFFF2B33D),
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconEnabledColor: Colors.black,
                                    iconSize: MediaQuery.of(context).size.width*0.06,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.06),
                                    underline: Container(
                                      height: MediaQuery.of(context).size.height*0.001,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? data) {
                                      setState(() {
                                        dropdowncategoria = data.toString();
                                      });
                                    },
                                    items: nominaciones.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        value: value['categoria'],
                                        child: Text(value['categoria'],  style: GoogleFonts.prata(
                                            textStyle:
                                            TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                                      );
                                    }).toList(),
                                  ),
                                  nominaciones.isNotEmpty ? (
                                      Container(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget> [
                                                DropdownButton<String>(
                                                  hint: Text("Selecciona un país para votar",style: GoogleFonts.prata(
                                                      textStyle:
                                                      TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                                                  isExpanded: true,
                                                  value: dropdownpais,
                                                  dropdownColor: Color(0xFFF2B33D),
                                                  icon: Icon(Icons.arrow_drop_down),
                                                  iconEnabledColor: Colors.black,
                                                  iconSize:  MediaQuery.of(context).size.width*0.06,
                                                  elevation: 16,
                                                  style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.06),
                                                  underline: Container(
                                                    height: MediaQuery.of(context).size.height*0.001,
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
                                                          textStyle:
                                                          TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width*0.04))),
                                                    );
                                                  }).toList(),
                                                ),
                                                Material(
                                                    color: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.4),
                                                    ),
                                                    child:
                                                    IconButton(
                                                      icon: Icon(Icons.thumb_up),
                                                      color: Color(0xFF023859),
                                                      iconSize: MediaQuery.of(context).size.width*0.15,
                                                      onPressed: () {
                                                        if(dropdowncategoria==null)
                                                        {
                                                          scaffoldMessenger.showSnackBar(SnackBar(content:Text("Por favor selecciona una categoría por la cual votar",  style: GoogleFonts.prata(
                                                              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                                              backgroundColor: Colors.red));
                                                          return;
                                                        }
                                                        if(dropdownpais==null)
                                                        {
                                                          scaffoldMessenger.showSnackBar(SnackBar(content:Text("Por favor selecciona un país por el cual votar",  style: GoogleFonts.prata(
                                                              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
                                                              backgroundColor: Colors.red));
                                                          return;
                                                        }
                                                        else {
                                                          insertvote(dropdownpais, dropdowncategoria, comite, email, context);
                                                          nominaciones.removeWhere((item) =>
                                                          item['categoria'] == dropdowncategoria);
                                                          dropdowncategoria = null;
                                                          dropdownpais = null;
                                                          setState(() {});
                                                          //getAllnominaciones(nameuser);
                                                        }
                                                      },
                                                      //highlightColor: Colors.redAccent,
                                                      splashColor: Color(0xFF3B52D9),
                                                      splashRadius: 40,
                                                    )),
                                                Text(
                                                    "Votar",  style: GoogleFonts.prata(
                                                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.05, letterSpacing: 1)))
                                              ]))
                                  )
                                      : (Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget> [
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height*0.07,
                                          ),
                                          Text(
                                              "YA HAS VOTADO EN TODAS LAS CATEGORIAS", style: TextStyle(fontWeight: FontWeight.bold,
                                              color: Colors.red,fontSize: MediaQuery.of(context).size.width*0.05)),
                                        ],)))
                                ],
                              ),

                            ),
                          ]
                      ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //VISTA FOTOS
      Scaffold(
        backgroundColor: Color(0xFFF2F2F0),
        body: Stack(
          children:<Widget>[
            InAppWebView(
              key: webViewKey,
              initialUrlRequest:
              URLRequest(url: Uri.parse("https://drive.google.com/drive/folders/1NeSpUQr_VRcE0Oqj-LZNmZAwEhqzlvER?usp=sharing")),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest: (controller, origin,
                  resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller,
                  navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![ "http", "https", "file", "chrome",
                  "data", "javascript", "about"].contains(uri.scheme)) {
                  if (await canLaunch(url)) {
                    // Launch the App
                    await launch(
                      url,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress3) {
                if (progress3 == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress3 = progress3 / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url,
                  androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
              onReceivedHttpAuthRequest: (InAppWebViewController controller, URLAuthenticationChallenge challenge) async {
                return HttpAuthResponse(username: "admin", password: "admin", action: HttpAuthResponseAction.PROCEED);
              },
            ),
            progress3 < 1.0
                ? LinearProgressIndicator(value: progress3)
                : Container(),
          ],
        ),
      ),
      //VISTA ADMIN
      Scaffold(
        backgroundColor: Color(0xFFF2F2F0),
        body: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest:
              URLRequest(url: Uri.parse(alumnipage)),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest: (controller, origin,
                  resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller,
                  navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![ "http", "https", "file", "chrome",
                  "data", "javascript", "about"].contains(uri.scheme)) {
                  if (await canLaunch(url)) {
                    // Launch the App
                    await launch(
                      url,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress3) {
                if (progress3 == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress3 = progress3 / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url,
                  androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
              onReceivedHttpAuthRequest: (InAppWebViewController controller, URLAuthenticationChallenge challenge) async {
                return HttpAuthResponse(username: "admin", password: "admin", action: HttpAuthResponseAction.PROCEED);
              },
            ),
            progress3 < 1.0
                ? LinearProgressIndicator(value: progress3)
                : Container(),

            /*WebView(
    javascriptMode: JavascriptMode.unrestricted,
    initialUrl: "http://192.168.0.4:80/api/alumni.php", //de esta manera lo conectamos de manera local, si queremos que sea
        // ya en el servidor sería con la variable almacenada alumnipage
    onPageFinished:(value){
    setState(() {
    isLoading=true;
    });

    },

    ),

    (!isLoading)?Center(
    child: CircularProgressIndicator(
    backgroundColor:  Color(0xFF3B52D9),
    ),
    ):Container()*/
            /* ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          /*ElevatedButton(
                    child: Icon(Icons.arrow_back),
                    onPressed: () {
                      webViewController?.goBack();
                    },
                  ),
                  ElevatedButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: () {
                      webViewController?.goForward();
                    },
                  ),*/
          ElevatedButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),*/
          ],

        ),

      )
    ];
    return estatus==1? Scaffold(
        backgroundColor: Color(0xFF023859),
        appBar: AppBar(
          leading: InkWell(child: Icon(Icons.logout_rounded),onTap: () async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.clear();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new SignIn(),
              ),
            );
          },),
          title: Text(
            "UP Panammun 2023",
            textAlign: TextAlign.right,
            style: GoogleFonts.prata(
                textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
          ),
          backgroundColor: Color(0xFF023859),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.sync_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                if (nameuser!="admin") {
                  recarga(email, context);
                  if (mounted) {
                    //setState(() {

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
                    //});
                  }
                  else
                    return;
                }
                else {
                  webViewController?.reload();
                }
              },
            )
          ],
        ),
        bottomNavigationBar: nameuser!="admin" ? BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF023859),
          onTap: onTabTapped, // new
          selectedLabelStyle: GoogleFonts.prata(
              textStyle: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
          unselectedLabelStyle: GoogleFonts.prata(
              textStyle: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.025)),
          unselectedItemColor: Colors.white,
          //selectedItemColor: Color(0xFFF2B33D) ,
          currentIndex: _currentIndex, // new
          items: [

            BottomNavigationBarItem(
              icon: new Icon(Icons.home,
                  color: Color(0xFFF2F2F0)),
              label:'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,color: Color(0xFFF2F2F0)),
                label:'Mi Comité'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time,color: Color(0xFFF2F2F0)),
                label:'Cronómetro'
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.how_to_vote_outlined,color: Color(0xFFF2F2F0)),
              label:'Nominaciones',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.camera,color: Color(0xFFF2F2F0)),
              label:'Fotos',
            ),
          ],
        ):null,
        body: nameuser!="admin" ? _children[_currentIndex]
            :  _children[5]
    ): Scaffold(
        backgroundColor: Color(0xFF023859),
        appBar: AppBar(
          leading: InkWell(child: Icon(Icons.logout_rounded),onTap: () async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.clear();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new SignIn(),
              ),
            );
          },),
          title: Text(
            "UP Panammun 2023",
            textAlign: TextAlign.right,
            style: GoogleFonts.prata(
                textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
          ),
          backgroundColor:  Color(0xFF023859),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.sync_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                print("aqui");
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                recarga(email, context);
                print(mounted);
                if (mounted) {
                  //setState(() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  Home()));
                  //});
                }
                else
                  return;
              },
            )
          ],
        ),
        body: _children[0]
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex==3) {
        getAllpaises(comite);
        getAllnominaciones(nameuser);
      }
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        email = preferences.getString("email");
        nameuser = preferences.getString("name");
        colegio = preferences.getString("escuela");
        pais = preferences.getString("pais");
        comite = preferences.getString("comite");
        estatus = preferences.getInt("estatus");
        /*if (estatus == 0)
          statustring = "Pendiente";*/
        if (estatus == 1)
          statustring = "Aprobado";
        else {
          if (estatus == 2)
            statustring = "Rechazado";
          else
            statustring= "Pendiente";
        }
        print("Nombre de usuario");
        print(nameuser);
        print(nameuser!.length);
        print(estatus);
      });
    }
    else
      return;
  }

  recarga(email, BuildContext context) async
  {

    Map data = {
      "email": email,
    };
    print("click");
    print(data.toString());
    final  response= await http.post(
        Uri.parse(RECHARGE),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },


        body: data,
        encoding: Encoding.getByName("utf-8")
    )  ;
    /*if (mounted){
      print("aqui");
    setState(() {
      isLoading=false;
    });}
    else
      return;*/
    if (response.statusCode == 200) {
      print(response.body);
      Map<String,dynamic>resposne=json.decode(response.body);
      if(!resposne['error'])
      {
        Map<String,dynamic>user=resposne['data'];
        print(" User name ${user['name']}");
        //print(context);
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("${resposne['message']}",  style: GoogleFonts.prata(
            textStyle: TextStyle( letterSpacing: 1))),
            backgroundColor: Colors.green));
        savePref(1,user['name'],user['email'],user['id'],user['escuela'],user['comite'],user['pais'],user['estatus']);
      }else{
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Ocurrió un error al recargar la página",  style: GoogleFonts.prata(
            textStyle: TextStyle(letterSpacing: 1))),
            backgroundColor: Colors.red));
        print(" ${resposne['message']}");
      }
    } else {
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Porfavor intenta de nuevo",  style: GoogleFonts.prata(
          textStyle: TextStyle( letterSpacing: 1))),
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
  void reset(){
    if (countDown){
      setState(() =>
      duration = countdownDuration);
    } else{
      setState(() =>
      duration = Duration());
    }
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1),(_) => addTime());
  }

  void addTime(){
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0){
        timer?.cancel();
      } else{
        duration = Duration(seconds: seconds);

      }
    });
  }
  void addTimemanual(){
    var addSeconds = 1;
    if (countDown == true && estadocontainershoras == 1)
      addSeconds = 3600;
    if (countDown == true && estadocontainersminutos == 1)
      addSeconds = 60;
    if (countDown == true && estadocontainerssegundos == 1)
      addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      print (seconds);
      if (seconds <= 900)
        duration = Duration(seconds: seconds);
    });
  }
  void restTimemanual(){
    var addSeconds = 1;
    if (countDown == true && estadocontainershoras == 1)
      addSeconds = -3600;
    if (countDown == true && estadocontainersminutos == 1)
      addSeconds = -60;
    if (countDown == true && estadocontainerssegundos == 1)
      addSeconds = -1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds >= 1)
      duration = Duration(seconds: seconds);
    });
  }
  void stopTimer({bool resets = true}){
    if (resets){
      reset();
    }
    setState(() => timer?.cancel());
  }

  Widget buildTime(BuildContext context){
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours =twoDigits(duration.inHours);
    final minutes =twoDigits(duration.inMinutes.remainder(60));
    final seconds =twoDigits(duration.inSeconds.remainder(60));
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //buildTimeCardhoras(time: hours, header:'Horas', contexto:context, state: estadocontainershoras),
          //SizedBox(width: MediaQuery.of(context).size.width*0.03),
          buildTimeCardminutos(time: minutes, header:'Minutos',contexto:context, state: estadocontainersminutos),
          SizedBox(width: MediaQuery.of(context).size.width*0.03),
          buildTimeCardsegundos(time: seconds, header:'Segundos',contexto:context, state: estadocontainerssegundos),
        ]
    );
  }

  Widget buildTimeCardhoras({required String time, required String header, required BuildContext contexto, required state}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
          onTap: (){
                  setState((){
                    if (state == 0){
                      estadocontainershoras = 1;
                      estadocontainersminutos = 0;
                      estadocontainerssegundos = 0;
                    }
                    else {
                      estadocontainershoras = 0;
                    }
                  });
                  print("Container "+header+" clicked");
                  print(state);
                  },
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(contexto).size.width*0.04),
            decoration: BoxDecoration(
                color: Color(0xFF023859),
                borderRadius: BorderRadius.circular(10),
                border: (estadocontainershoras==1 && estadocontainersminutos==0 && estadocontainerssegundos==0)?Border.all(color: Colors.red):Border.all(color: Color(0xFF023859)),
            ),
            child: Text(
                time, style:  GoogleFonts.prata(
                textStyle:TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.white,fontSize: MediaQuery.of(contexto).size.width*0.08))),
          )),
          SizedBox(height: MediaQuery.of(contexto).size.height*0.03),
          Text(header,style: GoogleFonts.prata(
              textStyle:TextStyle(color: Colors.black,fontSize: MediaQuery.of(contexto).size.width*0.04))),
        ],
      );
  Widget buildTimeCardminutos({required String time, required String header, required BuildContext contexto, required state}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: (){
                setState((){
                  if (state == 0)
                    {
                      estadocontainershoras = 0;
                      estadocontainersminutos = 1;
                      estadocontainerssegundos = 0;
                    }
                  else
                    estadocontainersminutos = 0;
                });
                print("Container "+header+" clicked");
                print(state);
              },
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(contexto).size.width*0.04),
                decoration: BoxDecoration(
                  color: Color(0xFF023859),
                  borderRadius: BorderRadius.circular(10),
                  border: (estadocontainershoras==0 && estadocontainersminutos==1 && estadocontainerssegundos==0)?Border.all(color: Colors.red, width: 5.0):Border.all(color: Color(0xFF023859),width: 5.0),
                ),
                child: Text(
                    time, style:  GoogleFonts.prata(
                    textStyle:TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white,fontSize: MediaQuery.of(contexto).size.width*0.08))),
              )),
          SizedBox(height: MediaQuery.of(contexto).size.height*0.03),
          Text(header,style: GoogleFonts.prata(
              textStyle:TextStyle(color: Colors.black,fontSize: MediaQuery.of(contexto).size.width*0.04))),
        ],
      );
  Widget buildTimeCardsegundos({required String time, required String header, required BuildContext contexto, required state}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: (){
                setState((){
                  if (state == 0)
                    {
                      estadocontainershoras = 0;
                      estadocontainersminutos = 0;
                      estadocontainerssegundos = 1;
                    }
                  else
                    estadocontainerssegundos = 0;
                });
                print("Container "+header+" clicked");
                print(state);
              },
              child: Container(
                padding: EdgeInsets.all(MediaQuery.of(contexto).size.width*0.04),
                decoration: BoxDecoration(
                  color: Color(0xFF023859),
                  borderRadius: BorderRadius.circular(10),
                  border: (estadocontainershoras==0 && estadocontainersminutos==0 && estadocontainerssegundos==1)?Border.all(color: Colors.red, width: 5.0):Border.all(color: Color(0xFF023859), width: 5.0),
                ),
                child: Text(
                    time, style:  GoogleFonts.prata(
                    textStyle:TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.white,fontSize: MediaQuery.of(contexto).size.width*0.08))),
              )),
          SizedBox(height: MediaQuery.of(contexto).size.height*0.03),
          Text(header,style: GoogleFonts.prata(
              textStyle:TextStyle(color: Colors.black,fontSize: MediaQuery.of(contexto).size.width*0.04))),
        ],
      );

  Widget buildButtons(BuildContext context){
    final isRunning = timer == null? false: timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: (){
            if (isRunning){
              stopTimer(resets: false);
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF023859))),
          child:Text(
            "Parar",
            textAlign: TextAlign.center,
            style: GoogleFonts.prata(
                textStyle: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width*0.03),
        ElevatedButton(
          onPressed: stopTimer,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF023859))),
          child:Text(
            "Cancelar",
            textAlign: TextAlign.center,
            style: GoogleFonts.prata(
                textStyle: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
          ),
        ),
      ],
    )
        : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_circle_up),
                  color: Color(0xFF023859),
                  iconSize: MediaQuery.of(context).size.width*0.12,
                  onPressed: () {
                    addTimemanual();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_circle_down),
                  color: Color(0xFF023859),
                  iconSize: MediaQuery.of(context).size.width*0.12,
                  onPressed: () {
                    restTimemanual();
                  },
                ),
              ]
          ),
          ElevatedButton(
            onPressed: (){
              startTimer();
              estadocontainershoras = 0;
              estadocontainersminutos = 0;
              estadocontainerssegundos = 0;
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF023859))),
            child:Text(
              "Iniciar",
              textAlign: TextAlign.center,
              style: GoogleFonts.prata(
                  textStyle: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
            ),
          ),
        ]);

  }
}
class Page1 extends StatelessWidget {
  late ScaffoldMessengerState scaffoldMessenger ;
  String? nameuser;
  String? statustring ="";
  String? colegio ="";
  String? pais ="";
  String? comite ="";
  String? email="";

  Page1({this.email,this.nameuser, this.statustring, this.colegio, this.pais, this.comite});
  //const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0xFFF2F2F0)
              /*child: Image.asset(
                "assets/background.jpg",
                fit: BoxFit.fill,
              ),*/
            ),
            Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.05, MediaQuery.of(context).size.width*0.01, MediaQuery.of(context).size.width*0.05, MediaQuery.of(context).size.width*0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Bienvenido \n"+ nameuser.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.045,
                      ),
                    ),
                  ),
                  Text(
                    "Estado de registro: "+ statustring.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.04,
                      ),
                    ),
                  ),
                  Text(
                    "Colegio: "+ colegio.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.04,
                      ),
                    ),
                  ),
                  Text(
                    "País: "+ pais.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.04,
                      ),
                    ),
                  ),
                  Text(
                    "Comité: "+ comite.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prata(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: MediaQuery.of(context).size.width*0.04,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.width*0.05),
                      child:
                      ListView(
                          children: [
                            Container(
                              child: Column(
                                children: <Widget> [
                                  Text(
                                    "¿Qué es Panammun?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.prata(
                                      textStyle: TextStyle(
                                        color: Color(0xFFD96248),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: MediaQuery.of(context).size.width*0.045,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width*0.03,
                                  ),
                                  Text(
                                    "PANAMMUN es un Modelo de la Naciones Unidas, organizado por los alumnos de la Universidad Panamericana para estudiantes de preparatoria, los cuales participarán en cualquiera de los comités como representante de un Estado, con la finalidad de que puedan analizar distintas problemáticas reales de nuestro mundo actual y que, a través del desarrollo de distintas habilidades, adopten un papel activo en la resolución de dichos conflictos.",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.prata(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: MediaQuery.of(context).size.width*0.04,
                                      ),
                                    ),
                                  ),
                                  /*Text(
                                    "¿Cómo funcionamos?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.prata(
                                      textStyle: TextStyle(
                                        color: Color(0xFFD96248),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: MediaQuery.of(context).size.width*0.045,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width*0.03,
                                  ),
                                  Text(
                                    "Para ello, el Modelo está compuesto por 7 comités representativos de los que integran la estructura de las Naciones Unidas, los cuales se encargan de atender cuestiones de distintos ámbitos para lograr abarcar un mayor campo de acción en el marco global.De dichos comités, 5 se llevan a cabo en español, los cuales son Asamblea General, Consejo Económico y Social de las Naciones Unidas (ECOSOC), Organización Mundial de la Salud (OMS), ONU Mujeres y Organización de los Estados Americanos (OEA); y 2 se realizan en inglés, a saber, Security Council y Human Rights Committee.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.prata(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: MediaQuery.of(context).size.width*0.04,
                                      ),
                                    ),
                                  ),*/
                                  Text(
                                    "Síguenos en redes sociales",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.prata(
                                      textStyle: TextStyle(
                                        color: Color(0xFFD96248),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: MediaQuery.of(context).size.width*0.045,
                                      ),
                                    ),
                                  ),
                                  Row (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:<Widget>[
                                      IconButton(
                                        onPressed: (){
                                          launch('https://www.tiktok.com/@panammun2022?_t=8VrA4KY8tFe&_r=1');
                                        },
                                        icon: FaIcon(FontAwesomeIcons.tiktok, color: Color(0xFF023859)),
                                        iconSize: MediaQuery.of(context).size.width*0.1,
                                        //cart+ icon from FontAwesome
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          launch('https://www.instagram.com/panammun?igshid=YmMyMTA2M2Y=');
                                        },
                                        icon: FaIcon(FontAwesomeIcons.instagramSquare, color: Color(0xFF023859)),
                                        iconSize: MediaQuery.of(context).size.width*0.1,
                                        //cart+ icon from FontAwesome
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          launch('https://www.facebook.com/modelo.panammun');
                                        },
                                        icon: FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF023859)),
                                        iconSize: MediaQuery.of(context).size.width*0.1,
                                        //cart+ icon from FontAwesome
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          launch('https://www.twitter.com/panammun_up?s=11&t=zFwhJjBRBAGJDPWh2QUYcw');
                                        },
                                        icon: FaIcon(FontAwesomeIcons.twitter, color: Color(0xFF023859)),
                                        iconSize: MediaQuery.of(context).size.width*0.1,
                                        //cart+ icon from FontAwesome
                                      ),
                                    ],
                                  ),
                                  Column (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:<Widget>[
                                      Text(
                                        "Contáctanos",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.prata(
                                          textStyle: TextStyle(
                                            color: Color(0xFFD96248),
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            fontSize: MediaQuery.of(context).size.width*0.045,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed:  (){
                                          _sendmailto();
                                          //launch('mailto:panammun2022@gmail.com?subject=Duda Panammun&body=Buenas tardes, tengo la siguiente pregunta: ');
                                        },
                                        icon: FaIcon(Icons.contact_mail, color: Color(0xFF023859)),
                                        iconSize: MediaQuery.of(context).size.width*0.1,
                                        //cart+ icon from FontAwesome
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showDialog3(context, email);
                                        },
                                        child: Text(
                                          "Eliminar cuenta",
                                          style: GoogleFonts.prata(
                                              textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: MediaQuery.of(context).size.width*0.04,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5)),
                                        ),

                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  )
                                ],
                              ),

                            ),
                          ]
                      ),),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showDialog3(BuildContext context, String? email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Panammun 2023',  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          content: Text('¿Estás seguro de querer eliminar tu cuenta ' + email.toString() +'?, Toda tu información se perderá',  style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child:  Text('Cancelar',  style: GoogleFonts.prata(
                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            ),
            TextButton(
              onPressed: () => {
                eliminarcuenta(context, email),
              },
              child: Text('Sí, eliminar cuenta',  style: GoogleFonts.prata(
                  textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            ),
          ],
        );
      },
    );
  }

  eliminarcuenta(BuildContext context, email) async
  {
    var url =DELETEUSER;
    print(url);
    Map data = {
      'email':email
    };
    print(data);
    final  response= await http.post(
        Uri.parse(DELETEUSER),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8")
    )  ;
    print(response.statusCode);
    print(response.body.toString());
    if (response.statusCode == 200) {
      Map<String,dynamic>resposne=jsonDecode(response.body);
      if(!resposne['error'])
      {
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Cuenta eliminada exitosamente",  style: GoogleFonts.prata(
            textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03, letterSpacing: 1))),
            backgroundColor: Colors.green));
        Navigator.pop(context);
        await Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => SignIn()));

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
    Navigator.pop(context, 'OK');
  }
  _sendmailto() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'panammun2022@gmail.com',
      query: 'subject=Duda Panammun&body=Buenas tardes, tengo la siguiente pregunta: ', //add subject and body here
    );
    var url = params.toString();
    if ( await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({Key? key, this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UP Panammun 2023",
          textAlign: TextAlign.right,
          style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
        ),
        backgroundColor: Color(0xFF023859),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],*/
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
    );
  }
}




