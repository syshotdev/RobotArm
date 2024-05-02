using System;
using System.IO.Ports;
using Godot;

//[Signal]
//public delegate void SendMessageEventHandler(string message);

public partial class PortCommunicator : Node3D
{
	const int BaudRate = 2400;
	const int DataBits = 8; // I don't remember the amount.  EDIT: I still don't know it

	/* This code in comment is depreciated. (Because I don't know what type these are)
	  const int ParityBits = 0;
	  const int StopBits = 2;*/

	private SerialPort port;

	public override void _Ready()
	{
		port = new SerialPort();

		port.BaudRate = BaudRate;
		port.DataBits = DataBits;
		port.StopBits = StopBits.Two;
		port.Parity = Parity.None;

		// This stuff was from official docs, which is why it is confusing
		port.Handshake = Handshake.None;
		port.RtsEnable = true;

		port.DataReceived += new SerialDataReceivedEventHandler(ReceivedMessage);

		TestFunction();
	}

	private void TestFunction()
	{
		GD.Print(SerialPort.GetPortNames());
		ChangePort("/dev/ttyUSB0");
		SendMessage("!SCVER" + 13);
	}

	public void ChangePort(string portName)
	{
		port.Close();
		port.PortName = portName;
		port.Open();
	}

	public void SendMessage(string message)
	{
		char[] byteMessage = message.ToCharArray(); // Probably can just be optimized to port.WriteString
		port.Write(byteMessage, 0, byteMessage.Length);
	}

	private static void ReceivedMessage(object sender, SerialDataReceivedEventArgs e)
	{
		SerialPort tempPort = (SerialPort)sender;
		string indata = tempPort.ReadExisting();
		GD.Print("Data Recieved:");
		GD.Print(indata);
	}
}
