<%-- Header --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- MySQL Connection --%>
<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost/ShoppingBasket"
    user="root"  password="asdfghjk"/>
<sql:query dataSource="${snapshot}" sql="SELECT * FROM Products;" var="result" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Cart Page</title>
</head>
<body>
<center>
<h1>Shopping Cart</h1>

<%-- Handle buttons --%>
<c:choose>
    <%-- continue --%>
    <c:when test="${! empty param.continued}">
        <c:redirect url="products.jsp" />
    </c:when>
    <%-- update --%>
    <c:when test="${! empty param.update}">
        <%-- Update each param.key's cookie with new value. It does affect param.update but it is okay. --%>
        <c:forEach var="row" items="${param}">
            <c:set var="newkey" value="${row.key}" />
            <c:set var="newvalue" value="${row.value}" />
            <%
            Cookie newCookie = new Cookie(pageContext.getAttribute("newkey").toString(), pageContext.getAttribute("newvalue").toString());
            newCookie.setMaxAge(365 * 60 * 60 * 24);
            response.addCookie(newCookie);
            %>
        </c:forEach>
        <c:redirect url="cart.jsp" />
    </c:when>
    <%-- confirm --%>
    <c:when test="${! empty param.confirm}">
        <c:redirect url="confirm.jsp" />
    </c:when>
</c:choose>

<%-- Check if logged in --%>
<c:choose>
    <%-- If in, display cart --%>
    <c:when test="${cookie.login.value.equals('true')}">
    <form>
        <c:out value="Welcome to shopping cart page, Username: ${cookie.userid.value}" />
        <table border="1" width="100%">
            <tr>
                <td>Product ID</td>
                <td>Product Price</td>
                <td>Quantity</td>
                <td>Total Price</td>
                <td>Change Quantity</td>
            </tr>
            <c:set var="totalprice" value="0" />
            <c:forEach var="row" items="${result.rows}">
                <c:if test="${! empty cookie[row.pid]}">
                    <tr>
                        <td><c:out value="${row.pid}"/></td>
                        <td><c:out value="${row.price}"/></td>
                        <td><c:out value="${cookie[row.pid].value}" /></td>
                        <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${row.price * cookie[row.pid].value}" /></td>
                        <c:set var="totalprice" value="${totalprice + row.price * cookie[row.pid].value}" />
                        <td><input type="number" name="${row.pid}" value="${cookie[row.pid].value}"></td>
                    </tr>
                </c:if>
            </c:forEach>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td><fmt:formatNumber type="number" maxFractionDigits="3" value="${totalprice}" /></td>
            </tr>
        </table>
        <%-- Three other buttons: continue, update and place --%>
        <input type="submit" name="continued" value="Continued">
        <input type="submit" name="update" value="Update">
        <input type="submit" name="confirm" value="Confirm Order">
    </form>
    </c:when>

    <c:otherwise>
        <c:out value="You did not login. Please login first, otherwise you can only view products and your operations will not work" />
        <a href="index.jsp">Go back to index page</a>
    </c:otherwise>
</c:choose>
</center>
</body>