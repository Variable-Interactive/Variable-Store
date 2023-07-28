<p align="center">
    <a href="https://github.com/Variable-Interactive/Variable-Store/releases">
        <img src="https://img.shields.io/github/downloads/Variable-Interactive/Variable-Store/total?color=lightgreen" alt="Downloads" />
    </a>
</p>

This is where the Variable Store Extension Fetches data from

![Store](https://user-images.githubusercontent.com/77773850/164515247-1e11123d-c071-42d4-9b4e-275de492dce6.png)<p>

### Rules for writing a store_info file
1. The main store info file (whose link you put in STORE_LINK) must have an integer number at the top (which indicates current store version). and the 1st extension entry should be of the store itself. **Sub-store info files** (whose links you can add later in the option tab) does NOT have to do this!
2. The Store Entry is an array of the format:
   - `["Display Name", 0.1, "Description", ........... ,"Image link", "{repo}/raw/{Path of extension within repo}"]`
   - The quotation marks ("") should not be removed
   - `0.1` is the version of the extension (usually obtained from extension.json of the extension)
   - Anything value/values can be placed between `"Description"` and `"Image link"` (with proper commas offcourse). However if you are placing an array there then the first element of that array must be a string (with ""). That string will be used as a keyword to tell the store what it is (currently, "Tags" is the only recognized keyword) 
   - `Image link` is the link you get by right clicking an image (uploaded somewhere on the internet) and selecting **Copy Image Link**
   - `"{repo}/raw/{Path of extension within repo}"` (if `https://github.com/Variable-ind/Pixelorama-Extensions/`blob`/master/Extensions/Example.pck` is the URL path to your extension then replace **blob** with **raw**
   - and the link becomes "`"https://github.com/Variable-ind/Pixelorama-Extensions/`raw`/master/Extensions/Example.pck"`"
4. One store entry must occupy only one line (and vice-versa)
3. Comments are supported. you can comment an entire line by placing `#` at the start of the line (comments between or at end of line are not allowed).

