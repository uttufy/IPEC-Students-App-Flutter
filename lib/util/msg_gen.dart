String genShareMessage(String? title, String? date, String url, String? credit) =>
    """IPEC Notice
----
Title : $title
Date : $date

Link [PDF] : ${Uri.parse(url).toString()}
----
Contributed by : $credit
on IPEC Student's app 
Android :  http://bit.ly/ipecapp 
IOS : http://bit.ly/ipecappios
""";
