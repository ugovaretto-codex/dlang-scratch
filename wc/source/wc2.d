import std.algorithm, std.stdio, std.string;
import std.algorithm.iteration;
import std.ascii;
void main(string[] args)
{
    const uint CHUNK_SIZE = 0x10000;
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
        dchar lastChar = ' ';
        foreach(chunk; File(args[1]).byChunk(CHUNK_SIZE))
        {
            if (chunk.empty) break;
            bool discardFirst = !isBlank(lastChar) && !isBlank(chunk[0]);
            version(each) //faster
            {
                chunk.splitter!(x => isBlank(x)).each!(w => wordCount += !w.empty);
            }
            else
            {
                wordCount += chunk.splitter!(x => isBlank(x)).map!(w => w.empty).sum();
            }
            if (discardFirst)
            {
                wordCount -= 1;
            }
            lastChar = chunk[chunk.length - ulong(1)];
        }
        writeln(wordCount);
    } catch (Exception e) {
        stderr.writeln("Error: ", e);
    }
}


static bool isBlankChar(dchar c) @safe pure nothrow @nogc
{
    //copied from isWhite implementation
    return  c == ' ' || (c >= 0x09 && c <= 0x0D);
}
