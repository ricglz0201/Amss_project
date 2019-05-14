import 'package:amss_project/widgets/stack_widget.dart';
import 'package:flutter/material.dart';
import 'package:amss_project/extra/auth.dart';
import 'package:amss_project/widgets/submit_button.dart';
import 'package:rich_alert/rich_alert.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  BuildContext _context;
  bool _isIos, _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar( title: Text('Iniciar sesión')),
      body: StackWidget(condition: _isLoading, body: _showBody())
    );
  }

  Widget _showBody() => Container(
    padding: EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _showLogo(),
          _showEmailInput(),
          _showPasswordInput(),
          SubmitButton(
            label: 'Iniciar sesión',
            function: _validateAndSubmit,
          ),
        ],
      ),
    )
  );

  void _validateAndSubmit() async {
    setState(() { _isLoading = true; });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        super.widget.onSignedIn();
        print('Signed in: $userId');
      } catch (e) {
        print('Error: $e');
        _showPopup(_isIos ? e.details : e.message);
      }
    }
    setState(() { _isLoading = false; });
  }

  void _showPopup(String subtitle) {
    showDialog(
      context: _context,
      builder: (BuildContext context) => RichAlertDialog(
        alertTitle: richTitle('Error'),
        alertSubtitle: richSubtitle(subtitle),
        alertType: RichAlertType.ERROR,
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: (){Navigator.pop(context);},
          ),
        ],
      )
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showLogo() => Hero(
    tag: 'hero',
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.0, 35.0, 0, 35.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50.0,
        child: Image.asset('assets/tec_logo.jpg'),
      ),
    ),
  );

  Widget _showEmailInput() => TextFormField(
    maxLines: 1,
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    decoration: InputDecoration(
      hintText: 'Email',
      icon: Icon(Icons.mail, color: Colors.grey)
    ),
    validator: _mailValidator,
    onSaved: (value) => _email = value,
  );

  String _mailValidator(value) {
    if(value.isEmpty) return 'El correo no puede estar vacío';
    RegExp exp = RegExp(r"[aAlL][0-9]{8}@(itesm|tec).mx");
    return exp.hasMatch(value) ? null : 'El formato no es el correcto';
  }

  Widget _showPasswordInput() => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: TextFormField(
      maxLines: 1,
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          )),
      validator: (value)
        => value.isEmpty ? 'La contraseña no puede estar vacía' : null,
      onSaved: (value) => _password = value,
    ),
  );
}