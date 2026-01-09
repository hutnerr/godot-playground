using Godot;
using System;

namespace Toolbox;

/// <summary>
/// Custom logger autoload for game events with colored output and log levels.
/// Usage in C#: Clogger.Instance.Log("state", "Player changed state");
/// Usage in GDScript: Clogger.log("state", "Player changed state")
/// </summary>
public partial class Clogger : Node
{
    public static Clogger Instance { get; private set; }
    
    public enum LogLevel
    {
        DEBUG,
        INFO,
        WARN,
        ERROR,
        NONE
    }
    
    public bool Disabled { get; set; } = false;
    public bool DebugEnabled { get; set; } = true;
    public bool ShowTimestamps { get; set; } = true;
    public LogLevel MinLogLevel { get; set; } = LogLevel.DEBUG;
    
    public override void _Ready()
    {
        Instance = this;
        info("Initialized Clogger");
    }
    
    private void InternalLog(string tag, string msg, string color = "", LogLevel level = LogLevel.INFO)
    {
        if (Disabled || level < MinLogLevel)
            return;
        
        string output = "";
        
        if (ShowTimestamps)
        {
            var time = DateTime.Now;
            output = $"[{time:HH:mm:ss}] ";
        }
        
        if (!string.IsNullOrEmpty(color))
        {
            output += $"[color={color}]{tag,-8}[/color] | {msg}";
            GD.PrintRich(output);
        }
        else
        {
            output += $"{tag,-8} | {msg}";
            GD.Print(output);
        }
    }
    
    public void log(string tag, string msg)
    {
        string formattedTag = $"[{tag.ToUpper()}]";
        InternalLog(formattedTag, msg, "cyan", LogLevel.INFO);
    }
    
    public void error(string msg)
    {
        GD.PushError(msg);
        InternalLog("[ERROR]", msg, "red", LogLevel.ERROR);
    }
    
    public void warn(string msg)
    {
        GD.PushWarning(msg);
        InternalLog("[WARN]", msg, "yellow", LogLevel.WARN);
    }
    
    public void debug(string msg)
    {
        if (DebugEnabled)
            InternalLog("[DEBUG]", msg, "gray", LogLevel.DEBUG);
    }
    
    public void action(string msg)
    {
        InternalLog("[ACTION]", msg, "magenta", LogLevel.INFO);
    }
    
    public void info(string msg)
    {
        InternalLog("[INFO]", msg, "green", LogLevel.INFO);
    }
}