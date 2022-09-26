import std.file;
import std.stdio;
import std.ascii;
import std.range;

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

static ulong countWords(const ref char[] s) pure nothrow @nogc
{
    if (s.empty) return 0;
    ulong cnt = 0;
    const ulong l =  s.length;
    auto p = &s[0];
    const auto e = p + l;
    version(isWhite)
    {
        alias isBlank = isWhite;
    } 
    else
    {
        alias isBlank = isBlankChar;
    }
    while (p < e)
    {
        //advance to next non blank char or end
        while (p < e && isBlank(*p)) {++p;}
        if (p >= e) break;
        //found word -> increment counter
        ++cnt;
        //advance to next blank char or end
        while (p < e && !isBlank(*p)) {++p;}
        if (p >= e) break;
    }
    return cnt;
}

static bool isBlankChar(dchar c) @safe pure nothrow @nogc
{
    //copied from isWhite implementation
    return  c == ' ' || (c >= 0x09 && c <= 0x0D);
}
