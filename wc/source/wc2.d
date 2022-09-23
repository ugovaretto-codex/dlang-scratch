import std.algorithm, std.stdio, std.string;
import std.algorithm.iteration;
import std.ascii;
void main(string[] args)
{
    
    static bool isBlankChar(dchar c) @safe pure nothrow @nogc
    {
        //copied from isWhite implementation
        return  c == ' ' || (c >= 0x09 && c <= 0x0D);
    }
    version(isWhite)
    {
        alias isBlank = isWhite;
    }
    else
    {
        alias isBlank = isBlankChar;
    }
    try {
        ulong wordCount = 0;
        //ulong lineCount = 0;
        foreach(line; File(args[1]).byLine)
        {
            version(each) //faster
            {
                line.splitter!(x => isBlank(x)).each!(w => wordCount += !w.empty);
            }
            else
            {
                wordCount += line.splitter!(x => isBlank(x)).map!(w => w.empty).sum();
            }

        }
        writeln(wordCount);
    } catch (Exception e) {
        writeln("Error: ", e);
    }
}
