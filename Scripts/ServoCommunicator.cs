using System;
using System.IO.Ports;
using System.Text;
using Godot;

public partial class ServoCommunicator : Node
{
	const int BaudRate = 2400;
	const int DataBits = 8; // I don't remember the amount.  EDIT: I still don't know it but it works
	const string portName = "/dev/ttyUSB0";

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

		// This is "temporary" but I won't fix it.
		ChangePort(portName);
	}

	private void TestFunction()
	{
		GD.Print(SerialPort.GetPortNames());
		ChangePort("/dev/ttyUSB0");
		SendMessage("!SCVER?" + Convert.ToChar(13));
	}

	public void ChangePort(string portName)
	{
		port.Close();
		port.PortName = portName;
		port.Open();
	}

	public void SendCommand(int servoIndex, int position, int ramp)
	{
    // OH DANG:
    // The PositionLowBit is like 7 bits instead of 8!
    // Unless the spec said that but I'd guess all paramaters transmitted are 8 bit
		byte positionLowBit = Convert.ToByte(position % 127);
		byte positionHighBit = Convert.ToByte(position >> 7);
		byte[] byteMessage = new byte[4];
		// I really wish I could put this in brackets :( []
		// First ServoIndex 1 byte, Ramp 1 byte, Position is 2 bytes
		byteMessage[0] = Convert.ToByte(servoIndex);
		byteMessage[1] = Convert.ToByte(ramp);
		byteMessage[2] = positionLowBit;
		byteMessage[3] = positionHighBit;

    //GD.Print(positionLowBit);
    //GD.Print(positionHighBit);

		// Example message: !SC(0)(63)(1)(255)(13) to make servo 0 to pos 511
		string message = "!SC" + byteMessage.GetStringFromUtf8() + Convert.ToChar(13);

    GD.Print(BitConverter.ToString(Encoding.UTF8.GetBytes(message)));
		port.WriteLine(message);
	}

	public void SendMessage(string message)
	{
		port.WriteLine(message);
	}

  // To get the ports when using GDScript
  public string[] GetPortNames()
  {
		GD.Print(SerialPort.GetPortNames());
		return SerialPort.GetPortNames();
  }

	// Technically this can be static but I want to use THIS class's port.
	private void ReceivedMessage(object sender, SerialDataReceivedEventArgs e)
	{
		SerialPort tempPort = (SerialPort)sender;
		string indata = tempPort.ReadExisting();
    //GD.Print("Data Recieved:");
		//GD.Print(indata);
	}
}
