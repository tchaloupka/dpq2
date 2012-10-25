module dpq2.fields;

import dpq2.answer;
import dpq2.libpq;
import std.string;

struct Field( T )
{
    string sqlPrefix;
    string sqlName;
    T value;
    
    //alias as!T as;
    
    @property
    string toString() nothrow
    {
        return "\""~( sqlPrefix.length ? sqlPrefix~"."~sqlName : sqlName )~"\"";
    }
}

struct Fields( TL ... )
{
    string toString()
    {
        string r;
        foreach( i, T; TL )
        {
            r ~= T.toString();
            if( i < TL.length-1 ) r ~= ", ";
        }
        
        return r;
    }
}

struct _Fields( FieldArray )
{
    FieldArray fields;
    
    @property
    string toString()
    {        
        string r = fields[0].toString;
        size_t i = 1;
        
        while ( i < fields.length )
        {
            r ~= ", " ~ fields[i].toString;
            i++;
        }
        
        return r;
    }
}

void _unittest( string connParam )
{
    auto conn = new Connection;
	conn.connString = connParam;
    conn.connect();

    Field!(PGtext) ft;
    ft.sqlPrefix = "pr1";
    ft.sqlName = "asd";
    
    Field!(PGinteger) fs;
    fs.sqlPrefix = "pr2";
    fs.sqlName = "fgh";
    
    Fields!( ft, fs ) f;
    
    import std.stdio;
    writeln( f.toString() );
}