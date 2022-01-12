import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_cors/angel3_cors.dart';
import 'package:file/file.dart';
import 'controllers/auth_controllers.dart' as auth_controllers;
import 'controllers/system_controllers.dart' as system_controllers;
import 'controllers/scheme_controllers.dart' as scheme_controllers;

/// Put your app routes here!
///
/// See the wiki for information about routing, requests, and responses:
/// * https://angel3-docs.dukefirehawk.com/guides/basic-routing
/// * https://angel3-docs.dukefirehawk.com/guides/requests-and-responses

AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // ParseBody middleware
    app.fallback((req, res) async {
      if (req.method == "POST") {
        await req.parseBody();
      }
      return true;
    });

    app.fallback(cors());

    // Typically, you want to mount controllers first, after any global middleware.
    await app.configure(system_controllers.configureServer);
    await app.configure(auth_controllers.configureServer);
    await app.configure(scheme_controllers.configureServer);

    // Throw a 404 if no route matched the request.
    app.fallback((req, res) => throw AngelHttpException.notFound());

    // Set our application up to handle different errors.
    //
    // Read the following for documentation:
    // * https://angel3-docs.dukefirehawk.com/guides/error-handling

    var oldErrorHandler = app.errorHandler;
    app.errorHandler = (e, req, res) async {
      if (req.accepts('text/html', strict: true)) {
        if (e.statusCode == 404 && req.accepts('text/html', strict: true)) {
          await res.render('error.html', {'message': 'No router exists for ${req.uri}'});
        } else {
          return await res.render('error.html', {
            'message': [e.message, '', e.stackTrace.toString().replaceAll('\n', '<br/>')].join('<br/>')
          });
        }
      } else {
        return await oldErrorHandler(e, req, res);
      }
    };
  };
}
