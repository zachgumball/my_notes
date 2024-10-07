import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:ar_flutter_plugin/datatypes/node_types.dart';

class Materi1 extends StatefulWidget {
  const Materi1({super.key});

  @override
  _Materi1State createState() => _Materi1State();
}

class _Materi1State extends State<Materi1> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  void onARViewCreated(
      ARSessionManager sessionManager, ARObjectManager objectManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Initialize AR session settings
    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
    );

    arObjectManager!.onInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cahaya dan Bunyi'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background2.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/matahari.jpg',
                    width: 370,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mengenal Cahaya dan Bunyi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 2, color: Colors.grey),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cahaya adalah radiasi elektromagnetik yang dapat dilihat oleh mata manusia. Ia memiliki panjang gelombang yang bervariasi, biasanya dalam rentang 380 hingga 750 nanometer. Cahaya adalah sumber energi yang memungkinkan proses fotosintesis pada tanaman dan mempengaruhi penglihatan manusia. Dalam ilmu fisika, cahaya juga dapat dianggap sebagai aliran partikel yang disebut foton dan dapat berperilaku sebagai gelombang. Cahaya dapat dipantulkan, dib refraksikan, dan diserap oleh berbagai material.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ARViewScreen()),
                    );
                  },
                  child: const Text('Tampilkan Objek 3D dalam AR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  _ARViewScreenState createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  void onARViewCreated(
      ARSessionManager sessionManager, ARObjectManager objectManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Initialize AR session settings
    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
    );

    arObjectManager!.onInitialize();
  }

  Future<void> onPlaceObject() async {
    var newNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "assets/models/AnimatedCube.gltf",
      scale: Vector3(0.2, 0.2, 0.2),
      position: Vector3(0, 0, 0),
      rotation: Vector4(0, 0, 0, 0),
    );

    // Coba tambahkan node
    bool? didAdd = await arObjectManager?.addNode(newNode);
    if (didAdd!) {
      print("3D Object added successfully!");
    } else {
      print("Failed to add 3D Object.");
    }
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR View')),
      body: ARView(
        onARViewCreated: (arSessionManager, arObjectManager, arAnchorManager,
            arCameraManager) {
          onARViewCreated(arSessionManager, arObjectManager);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPlaceObject,
        child: const Icon(Icons.add),
      ),
    );
  }
}
