import std.algorithm, std.stdio, std.string;
import std.algorithm.iteration;
import std.ascii;
void main(string[] args)
{
    static bool isBlank(dchar c) {
        return c == ' ' || c == '\t';
    }
    try {
        ulong wordCount = 0;
        //ulong lineCount = 0;
        foreach(line; File(args[1]).byLine)
        {
            wordCount += line.splitter!(x => isBlank(x)).map!(w => 1 * w.empty).sum();//each!((w)  {if (!w.empty) ++wordCount;});

        }
        writeln(wordCount);
    } catch (Exception e) {
        writeln("Error: ", e);
    }
}
