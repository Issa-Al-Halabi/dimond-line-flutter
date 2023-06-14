import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  List trips =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conn();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void conn(){
    print('conn');

    // String argument = 'your_argument';
    // IO.Socket socket = IO.io('your_socket_server_url/$argument');
    // socket.connect();
    //
    // // or
    // String argument = 'your_argument';
    // IO.Socket socket = IO.io('your_socket_server_url', <String, dynamic>{
    //   'query': 'argument=$argument',
    // });
    // socket.connect();

    // // Join a specific channel:
    // String channelName = 'your_channel_name';
    // socket.emit('subscribe', channelName);

    // // Listen for events on the specific channel:
    // socket.on(channelName, (data) {
    //   // Handle the received event data on the specific channel
    // });


    // Dart client
    IO.Socket socket = IO.io('http://localhost:3000');
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  //////////////////way 2
  late IO.Socket socket;
  void connectToServer() {
    // Replace 'your-websocket-api-url' with the actual URL of your WebSocket server
    socket = IO.io('your-websocket-api-url', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Connected to server');
      // TODO
      // socket.emit('subscribe', widget.userId);
      socket.emit('subscribe', '11');
    });

    socket.on('trips', (data) {
      // Handle the received data and update the trips list
      setState(() {
        final List<dynamic> jsonTrips = data;
        // TODO
        // trips = parseTrips(jsonTrips);
        trips = jsonTrips.toList();
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }



  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return ListTile(
            title: Text(trip.destination),
            subtitle: Text(trip.date),
          );
        },
      ),
    );
  }
}
