import std.file;
import std.stdio;
import std.ascii;
import std.range;

static bool isBlankChar(dchar c) @safe pure nothrow @nogc
{
    //copied from isWhite implementation
    return  c == ' ' || (c >= 0x09 && c <= 0x0D);
}

ulong countWords(char[] s) pure
{
    if (s.empty) return 0;
    ulong cnt = 0;
    ulong l =  s.length;
    ulong i = 0;
    version(isWhite)
    {
        alias isBlank = isWhite;
    } 
    else
    {
        alias isBlank = isBlankChar;
    }
    while (i < l)
    {
        //advance to next non blank char or end
        while (i < l && isBlank(s[i++])) {}
        if (i >= l) break;
        //found word -> increment counter
        ++cnt;
        //advance to next blank char or end
        while (i < l && !isBlank(s[i++])) {}
        if (i >= l) break;
    }
    return cnt;
}

void main(string[] args)
{
    try {
    auto f = File(args[1]);
    ulong wordCount = 0;
    ulong lineCount = 0;
    char[] buf;
    while (!f.eof)
    {
        f.readln(buf);
        ++lineCount;
        wordCount += countWords(buf); 
    }
    writeln(lineCount - 1, " ", wordCount);
    } catch(Exception e) {
        stderr.writeln("Error! ", e);
    }
}
