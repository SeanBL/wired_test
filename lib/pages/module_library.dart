import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import '.././utils/webview_screen.dart';
import '../main.dart';
import 'home_page.dart';


class ModuleLibrary extends StatefulWidget {

  @override
  _ModuleLibraryState createState() => _ModuleLibraryState();
}

class ModuleFile {
  final FileSystemEntity file;
  final String path;


  ModuleFile({required this.file, required this.path});
}

enum DisplayType { modules, resources }

class _ModuleLibraryState extends State<ModuleLibrary> {
  late Future<List<ModuleFile>> futureModules;
  late Future<List<FileSystemEntity>> futureResources; // For PDF resources
  List<ModuleFile> modules = [];
  List<FileSystemEntity> resources = []; // Store PDF files
  DisplayType selectedType = DisplayType.modules; // To track whether Modules or Resources are selected

  @override
  void initState() {
    super.initState();
    futureModules = _fetchModules();
    futureResources = _fetchResources(); // Fetch the resources
  }

  Future<List<ModuleFile>> _fetchModules() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      // Get all files from the directory
      setState(() {
        modules = directory
            .listSync()
            .whereType<File>()
            .map((file) => ModuleFile(file: file, path: file.path))
            .toList();
      });
      // check this later
      return modules;
    } else {
      return [];
    }
  }

  Future<List<FileSystemEntity>> _fetchResources() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      setState(() {
        resources = directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.pdf')) // Only PDF files
            .toList();
      });
      return resources;
    } else {
      return [];
    }
  }

  Future<void> deleteFileAndAssociatedDirectory(String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        return;
      }
      // Define the path to the file
      final filePath = '${directory.path}/$fileName';

      // Read the htm file
      final file = File(filePath);
      print('attempting to delete file: $filePath');
      if (!await file.exists()) {
        print('File not found: $filePath');
        return;
      }

      final fileContent = await file.readAsString();
      print('File content read successfully: ${fileContent.substring(0, 150)}...');

      // Use RegEx to find the path to the directory
      final regEx = RegExp(r'files/(\d+(-[a-zA-Z0-9]+-\d+)?|\d+[a-zA-Z0-9]+)/');
      final match = regEx.firstMatch(fileContent);
      print('match: $match');
      if (match != null) {
        final directoryName = match.group(1);
        final directoryPath = '${directory.path}/files/$directoryName';
        print('directoryPath resolved to: $directoryPath');

        // Delete HTM file
        await file.delete();
        print('Deleted file: $filePath');

        // Delete directory
        final dir = Directory(directoryPath);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
          print('Deleted directory: $directoryPath');

        } else {
          print('Directory not found: $directoryPath');
        }

        // Update the state to remove the deleted file from the list
        setState(() {
          modules.removeWhere((module) => module.path == filePath);
        });

      } else if (match == null) {
        print('No match found in file: $filePath');
        return;
      }
    } catch (e) {
      print('Error deleting file or directory: $e');
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF0DC),
                  Color(0xFFF9EBD9),
                  Color(0xFFFFC888),
                ],
              ),
            ),
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.transparent,
                  //   ),
                  //     child: Row(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             Navigator.pop(context);
                  //           },
                  //           child: Row(
                  //             children: [
                  //               SvgPicture.asset(
                  //                 "assets/icons/chevron_left.svg",
                  //                 width: 28,
                  //                 height: 28,
                  //               ),
                  //                 const Text(
                  //                   "Back",
                  //                   style: TextStyle(
                  //                     fontSize: 24,
                  //                     fontWeight: FontWeight.w500,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                    const SizedBox(height: 30,),
                  const Text(
                    "My Library",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0070C0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  // Display the modules or resources
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedType = DisplayType.modules;
                                  });
                                },
                            child: Container(
                              height: 75,
                              color: selectedType == DisplayType.modules
                                  ? Colors.white
                                  : Colors.grey[300],
                              child: const Center(
                                child: Text(
                                  "Modules",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 75,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = DisplayType.resources;
                              });
                            },
                          child: Container(
                            height: 75,
                            color: Colors.white,
                            child: const Center(
                              child: Text(
                                "Resources",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ),
                          ),
                          ),
                      ],
                    ),
                  ),
                  // Display appropriate list based on selectedType
                  // Continue here 9/5/2024
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Stack(
                      children: [
                        Container(
                          // height: 600,
                          height: screenHeight * 0.6,
                        child: FutureBuilder<List<ModuleFile>>(
                          future: futureModules,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Error loading modules'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No modules found'));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == snapshot.data!.length) {
                                  // This is the last item (the SizedBox or Container)
                                    return const SizedBox(
                                      height: 120,
                                    );
                                  }
                                  final moduleFile = snapshot.data![index];
                                  // start here to add the fade functionality and scroll functionality. Use module info as reference.
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            // border: Border(
                                            //   top: BorderSide(
                                            //     color: Colors.black,
                                            //     width: 1,
                                            //   ),
                                            //   bottom: BorderSide(
                                            //     color: Colors.black,
                                            //     width: 1,
                                            //   ),
                                            // ),
                                        ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 0, left: 0),
                                        child: ListTile(
                                          title: Text(
                                              moduleFile.file.path.split('/').last,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                          ),

                                          //leading: const Icon(Icons.insert_drive_file),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                  height: 69,
                                                  width: 69,
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xFF87C9F8),
                                                        Color(0xFF70E1F5),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Play the module
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => WebViewScreen(
                                                                  urlRequest: URLRequest(
                                                                    url: Uri.file(moduleFile.path),
                                                                  ),
                                                                )
                                                            ),
                                                      );
                                                      // WebViewScreen();
                                                    },
                                                    child: const Column(
                                                      children: [
                                                        Icon(
                                                            Icons.play_arrow,
                                                            color: Color(0xFF545454),
                                                            size: 26,
                                                        ),
                                                        Text(
                                                          "Play",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF545454),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Flexible(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                    height: 69,
                                                    width: 69,
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xFF70E1F5),
                                                        Color(0xFF86A8E7),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("Delete tapped");
                                                      deleteFileAndAssociatedDirectory(moduleFile.file.path.split('/').last);
                                                    },
                                                    child: const Column(
                                                      children: [
                                                        Icon(
                                                            Icons.delete,
                                                            color: Color(0xFF545454),
                                                            size: 26,
                                                        ),
                                                        Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF545454),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ),
                                              ),
                                            ]
                                          ),
                                        ),
                                      ),
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.grey,
                                      )
                                    ],
                                  );
                                }
                              );
                            }
                          },
                        ),
                      ),
                        // Fade in the module list
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    colors: [
                                      // Colors.transparent,
                                      // Color(0xFFFFF0DC),
                                      //Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                                      Color(0xFFFECF97).withOpacity(0.0),
                                      Color(0xFFFECF97),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                  ),
                  ),
                ],
              ),
            ),
          ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                color: Colors.transparent,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'WiRED International'))),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.home, size: 36, color: Colors.black),
                          Text("Home", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => print("My Library"),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.library_books, size: 36, color: Colors.black),
                          Text("My Library", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => print("Help"),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info, size: 36, color: Colors.black),
                          Text("Help", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}