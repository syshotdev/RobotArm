using System;
using System.IO.Ports;
using Godot;

public partial class PortCommunicator : Node3D
{
    const int BaudRate = 2400;
    const int DataBits = 8; // I don't remember the amount.  EDIT: I still don't know it
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
        SendCommand("!SCVER" + 13);
    }

    public void ChangePort(string portName)
    {
        port.Close();
        port.PortName = portName;
        port.Open();
    }

    public void SendCommand(string command)
    {
        GD.Print("Just to make sure, this is what you're sending: " + command);
        char[] byteMessage = command.ToCharArray(); // Probably can just be optimized to port.WriteString
        port.Write(byteMessage, 0, byteMessage.Length);
    }

    // Technically this can be static but I want to use THIS class's port.
    private void ReceivedMessage(object sender, SerialDataReceivedEventArgs e)
    {
        SerialPort tempPort = (SerialPort)sender;
        string indata = tempPort.ReadExisting();
        GD.Print("Data Recieved:");
        GD.Print(indata);
    }
}
