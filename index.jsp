<%-- Header --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%-- MySQL Connection --%>
<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost/ShoppingBasket"
    user="root"  password="asdfghjk"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Index Page: ShoppingBasket</title>
</head>
<body>
<center>
<h1>Entry Point to ShoppingBasket</h1>

<c:choose>

    <%-- Check if logged in --%>
    <c:when test="${cookie.login.value.equals('true')}">
        Welcome back! <br /> 
        <c:out value="${cookie.userid.value}">NO NAME</c:out>
        
        <%-- Show logout button --%>
        <form action="logout.jsp" method="post">
            <input type="submit" value="Logout" />
        </form>
        
        <%-- Show all orders --%>
        <b>All orders</b>
        <sql:query dataSource="${snapshot}" sql="SELECT * FROM Purchases WHERE aname='${cookie.userid.value}';" var="result" />
        <table border="1" width="100%">
            <tr>
                <td>Order ID</td>
                <td>Product ID</td>
                <td>Quantity</td>
                <td>Order Time</td>
            </tr>
            <c:forEach var="row" items="${result.rows}">
                <tr>
                    <td><c:out value="${row.id}"/></td>
                    <td><c:out value="${row.pid}"/></td>
                    <td><c:out value="${row.quantity}"/></td>
                    <td><c:out value="${row.purchase_time}" /></td>
                </tr>
            </c:forEach>
        </table>
        
        <%-- go to product page --%>
        <a href="products.jsp">Go to products page</a>
    </c:when>
    
    <%-- If not logged in, should login or register --%>
    <c:otherwise>
        Please login first:
        <form action="login.jsp" method="post">
            Username: <input type="text" name="username">
            <br />
            Password: <input type="password" name="password" />
            <br />
            <input type="submit" value="Submit" />
        </form>
        <br />
        If you did not register, please register first:
        <form action="register.jsp" method="post">
            Username: <input type="text" name="username">
            <br />
            Password: <input type="password" name="password" />
            <br />
            Confirm Password: <input type="password" name="cpassword" />
            <input type="submit" value="Submit" />
        </form>
    </c:otherwise>
    
</c:choose>
</center>

</body>
</html>