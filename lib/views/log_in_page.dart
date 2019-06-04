import 'package:flash_it/controllers/file_controller/edit_user_settings.dart';
import 'package:flash_it/controllers/google_services_api.dart';
import 'package:flash_it/controllers/init.dart';
import 'package:flash_it/presentation/custom_icons_icons.dart';
import 'package:flash_it/widgets/log_in/animate_log_in.dart';
import 'package:flash_it/widgets/log_in/log_in_button.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  final Map<String, dynamic> formData = {'username': null, 'password': null};

  LogInPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> with TickerProviderStateMixin {
  bool _animationState = false;
  bool _loggedIn = false;
  AnimationController _controller;

  @override
  void initState() {
    _loggedIn = EditUserSettings.edit.settings.loggedIn;
    _animationState = false;
    _controller = new AnimationController(
      duration: new Duration(milliseconds: 3000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new ExactAssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  const Color.fromRGBO(230, 230, 230, 0.8),
                  const Color.fromRGBO(150, 150, 150, 0.9),
                ],
                stops: [0.2, 1.0],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              height: 550,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    CustomIcons.cards,
                                    color: Theme.of(context).primaryColor,
                                    size: 130,
                                  ),
                                  Text(
                                    'Flash It!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display3
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                  SizedBox(height: 50),
                                  Text(
                                    'Welcome${_loggedIn ? ' back!' : ''}',
                                    style: Theme.of(context).textTheme.headline,
                                  ),
                                  Text(
                                    _loggedIn
                                        ? 'Tap to continue'
                                        : 'Sign in to your google account to sync data',
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              )),
                        ],
                      ),
                      _getButton()
                    ])
              ],
            ),
          ),
        ),
      );

  void _handleLogInButton() async {
    final bool result = await GoogleServicesAPI.gService.signIn();

    if (result) _continue();
  }

  void _continue() {
    init.init().then((bool status) async {
      await GoogleServicesAPI.gService.syncData();
      setState(() {
        _animationState = true;
      });
      _playAnimation();
      return true;
    });
  }

  Future<Null> _playAnimation() async {
    try {
      await _controller.forward();
      await _controller.reverse();
    } on TickerCanceled {}
  }

  Widget _getButton() {
    final String buttonText = _loggedIn ? 'Start' : 'Sign in';
    return _animationState
        ? AnimateLogIn(
            buttonController: _controller.view, buttonText: buttonText)
        : Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: InkWell(
              onTap: _handleLogInButton,
              child: LogInButton(buttonText: buttonText),
            ),
          );
  }
}
