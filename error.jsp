<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Error Page</title>
</head>

<body>
<center>
    <h1>Error Page</h1>
    I am sorry but you got this error:
    <br />
    <b><% out.println(request.getParameter("errorInfo")); %></b>
    <br />
    <a href="index.jsp">Go back to index.jsp</a>
</center>
</body>

</html>