
## Karls Flutter Template

#### About me

As a hybrid between UX Designer and Software Developer I'm always on the keen on learning new skills. I like to share my learnings here, so all my effort is not lost in a void.<br>

Feel free to clone and share. Feedback is always welcome!

### Repositiory

My goal with this project was to setup a simple application to get to with Dart and Flutter. The application contains a few pages that let the user manage a list of products that and handled on a web server. I implemented some basic UI elements and a client that contains all the web requests.<br>

To simplify things I did not use a databank. Data is stored in a static List<> and will not persist.

##### Content

- Application: Flutter project for the Application (VS Code)
- Server: ASP .Net Core with SwaggerUI (VS2022)

##### How to
1. Open the Flutter Project "Karls Flutter Template" in VS Code and build the application or run it in an emulator (never tested it on iOs)
2. Open the Server Project "KarlsTemplate_Server" in VS and run it
3. Make sure everything is in the same network and ports 5000 and 5001 not blocked by the firewall
4. In the app: Hit the settings icon on the home page and make sure to enter the URL of the server (see command panel)

##### Application

The app contains:
- Home page with a link to the Settings page. 
- Dynamic Products page that lists all the available products
- Product Editor to add new products
- Product Details to delete or edit a product