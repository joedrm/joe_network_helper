import 'dart:convert';
import 'dart:io';

class UDPUtil {
  static RawDatagramSocket udpSocket;
  static bool isCollected = false;

  static initUDP() async {
    udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 9870);
    // print("startUDPServer");
    if (udpSocket == null) {
      return;
    }
    //监听套接字事件
    udpSocket.listen((event) {
      Datagram datagram = udpSocket.receive();
      if (datagram != null && datagram.data != null) {
        print("datagram = ${datagram.data}");
        print("data = " + utf8.decode(datagram.data));
        print("address = " + datagram.address.address);
        String result = utf8.decode(datagram.data);
        if (result == "SengledAck") {
          print("result = $result");
          udpSocket.send(datagram.data, datagram.address, 9871);
        }
      }
    });
    isCollected = true;
  }

  static void send(List<int> params, String ipAddress) {
    if (udpSocket == null) {
      return;
    }
    udpSocket.send(params, InternetAddress(ipAddress), 9860);
  }

  static void listen() {
    if (udpSocket == null) {
      return;
    }
    udpSocket.listen((event) {
      Datagram datagram = udpSocket.receive();
      if (datagram != null && datagram.data != null) {
        print("datagram = ${datagram.data}");
      }
    }, onError: (err) {
      print("err = ${err.toString()}");
    });
  }

  static void close(){
    if (udpSocket != null) {
      udpSocket.close();
      udpSocket = null;
    }
  }

  // UDP 客户端
  static void startUDPClient() async {
    RawDatagramSocket rawDgramSocket =
        await RawDatagramSocket.bind('127.0.0.1', 8082);
    rawDgramSocket.send(
        utf8.encode("hello,world!"), InternetAddress('127.0.0.1'), 8081);
    //监听套接字事件
    await for (RawSocketEvent event in rawDgramSocket) {
      if (event == RawSocketEvent.read) {
        // 接收数据
        print(utf8.decode(rawDgramSocket.receive().data));
      }
    }
  }

  // UDP 服务端
  static void startUDPServer() async {
    RawDatagramSocket rawDgramSocket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 9870);
    print("startUDPServer");
    //监听套接字事件
    await for (RawSocketEvent event in rawDgramSocket) {
      // 数据包套接字不能监听数据，而是监听事件。
      // 当事件为RawSocketEvent.read的时候才能通过receive函数接收数据
      if (event == RawSocketEvent.read) {
        print(utf8.decode(rawDgramSocket.receive().data));
        // rawDgramSocket.send(utf8.encode("UDP Server:already received!"), InternetAddress.loopbackIPv4, 8082);
      }
    }
  }
}
