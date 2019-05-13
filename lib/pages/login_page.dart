import 'package:amss_project/widgets/stack_widget.dart';
import 'package:flutter/material.dart';
import 'package:amss_project/extra/auth.dart';
import 'package:amss_project/widgets/submit_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password, _errorMessage = "";
  bool _isIos, _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
          _showErrorMessage()
        ],
      ),
    )
  );

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        super.widget.onSignedIn();
        print('Signed in: $userId');
      } catch (e) {
        print('Error: $e');
        setState(() { _errorMessage = _isIos ? e.details : e.message; });
      }
    }
    setState(() { _isLoading = false; });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300
        ),
        textAlign: TextAlign.center,
      );
    } return Container(height: 0.0);
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
    if(value.isEmpty) return 'Mail can\'t be empty';
    RegExp exp = RegExp(r"[aAlL][0-9]{8}@(itesm|tec).mx");
    return exp.hasMatch(value) ? null : 'The format isn\'t correct';
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
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value,
    ),
  );
}