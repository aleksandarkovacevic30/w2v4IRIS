Class Word2Vec.Main Extends %RegisteredObject
{

Property model As %SYS.Python;

Property gensim As %SYS.Python;

/// look at https://github.com/RaRe-Technologies/gensim-data for various vocabularies
/// default is glove-wiki-gigaword-100
Method %OnNew(vocabulary As %String) As %Status
{
    if vocabulary="" set vocabulary="glove-wiki-gigaword-100"
    // TODO import required classes
    try {
        set gensim = ##class(%SYS.Python).Import("gensim")
    } catch err {
        set status = ##class(%SYS.Python).Install("gensim")
        set gensim = ##class(%SYS.Python).Import("gensim")
    }
    set gensimD = ##class(%SYS.Python).Import("gensim.downloader")
    set ..model = gensimD.load(vocabulary)
    
    quit $$$OK
}

Method similarity(word1 As %String, word2 As %String) As %Numeric
{
    Quit ..model.similarity(word1,word2).item()
}

Method mostsimilar(word As %String) As %SYS.Python [ Language = python ]
{
    return self.model.most_similar(word)
}

// Odd-One-Out from list of strings

// list is a $listbuild

Method oddmanout(list) As %String
{
    set myPyList=##class(Py.Helper).toPyListOrString(list)
    Quit ..model."doesnt_match"(myPyList)
}

}
