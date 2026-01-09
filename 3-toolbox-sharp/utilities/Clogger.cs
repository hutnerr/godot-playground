using Godot;
using System;

namespace Toolbox;

/// <summary>
/// Custom logger for game events with colored output and log levels.
/// Usage: Clogger.Log("state", "Player changed state");
/// </summary>
public static class Clogger
{
    public enum LogLevel
    {
        DEBUG,
        INFO,
        WARN,
        ERROR,
        NONE
    }
    
    public static bool Disabled { get; set; } = false;
    public static bool DebugEnabled { get; set; } = true;
    public static bool ShowTimestamps { get; set; } = true;
    public static LogLevel MinLogLevel { get; set; } = LogLevel.DEBUG;
    
    private static void InternalLog(string tag, string msg, string color = "", LogLevel level = LogLevel.INFO)
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
    
    public static void Log(string tag, string msg)
    {
        string formattedTag = $"[{tag.ToUpper()}]";
        InternalLog(formattedTag, msg, "cyan", LogLevel.INFO);
    }
    
    public static void Error(string msg)
    {
        GD.PushError(msg);
        InternalLog("[ERROR]", msg, "red", LogLevel.ERROR);
    }
    
    public static void Warn(string msg)
    {
        GD.PushWarning(msg);
        InternalLog("[WARN]", msg, "yellow", LogLevel.WARN);
    }
    
    public static void Debug(string msg)
    {
        if (DebugEnabled)
            InternalLog("[DEBUG]", msg, "gray", LogLevel.DEBUG);
    }
    
    public static void Action(string msg)
    {
        InternalLog("[ACTION]", msg, "magenta", LogLevel.INFO);
    }
    
    public static void Info(string msg)
    {
        InternalLog("[INFO]", msg, "green", LogLevel.INFO);
    }
}