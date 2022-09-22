import std.algorithm, std.stdio, std.string;
// Count words in a file using ranges.
void main(string[] args)
{
    try {
        auto file = File(args[1]); // Open for reading
        const wordCount = file.byLine            // Read lines
                              .map!split           // Split into words
                              .map!(a => a.length) // Count words per line
                              .sum();              // Total word count
        writeln(wordCount);
    } catch (Exception e) {
        writeln("Error: ", e);
    }
}
