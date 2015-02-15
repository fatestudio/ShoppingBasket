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
<title>Product Page</title>
</head>
<body>
<center>

<%-- Check if logged in --%>
<c:choose>
    <c:when test="${cookie.login.value.equals('true')}">
        <c:out value="Welcome to products page, Username: ${cookie.userid.value}" />
    </c:when>
    <c:otherwise>
        <c:out value="You did not login. Please login first, otherwise you can only view products and your operations will not work" />
    </c:otherwise>
</c:choose>
<br />

<h1>Product List</h1>

<%-- Handle buttons --%>
<c:choose>
    <%-- submit --%>
    <c:when test="${! empty param.submit}">
        <c:redirect url="cart.jsp" />
    </c:when>
    <%-- reset --%>
    <c:when test="${! empty param.reset}">
        <c:forEach var="row" items="${result.rows}">
            <c:if test="${! empty cookie[row.pid]}">
                <c:set var="newkey" value="${row.pid}" />
                <%
                Cookie newCookie = new Cookie(pageContext.getAttribute("newkey").toString(), "0");
                newCookie.setMaxAge(365 * 60 * 60 * 24);
                response.addCookie(newCookie);
                %>
            </c:if>
        </c:forEach>
        <%
        Cookie newCookie = new Cookie("total", "0");
        newCookie.setMaxAge(365 * 60 * 60 * 24);
        response.addCookie(newCookie);
        %>
        <c:redirect url="products.jsp" />
    </c:when>
    
    <%-- Handle Add --%>
    <c:when test="${fn:length(param) > 0}">
        <c:forEach var="row" items="${param}">
            <b><c:out value="${row.key} added!"/></b>
            
            <%-- Add this item --%>
            <c:choose>
            
                <c:when test="${empty cookie[row.key]}">
                    <c:set var="newkey" value="${row.key}" />
                    <%
                    String newkey = pageContext.getAttribute("newkey").toString();
                    Cookie newCookie = new Cookie(newkey, "1");
                    // Unit: second
                    newCookie.setMaxAge(365 * 60 * 60 * 24);
                    response.addCookie(newCookie);
                    %>
                    
                    <%-- Update cookie.total --%>
                    <c:choose>
                        <c:when test="${empty cookie.total}">
                            <%
                            Cookie totalCookie = new Cookie("total", "1");
                            // Unit: second
                            totalCookie.setMaxAge(365 * 60 * 60 * 24);
                            response.addCookie(totalCookie);
                            %>
                        </c:when>
                        <c:otherwise>
                            <fmt:parseNumber var="oldvalue" type="number" value="${cookie.total.value}" />
                            <c:set var="newvalue" value="${oldvalue + 1}" />
                            <%
                            Cookie totalCookie = new Cookie("total", pageContext.getAttribute("newvalue").toString());
                            totalCookie.setMaxAge(365 * 60 * 60 * 24);
                            response.addCookie(totalCookie);
                            %>
                        </c:otherwise>
                    </c:choose>
                    
                    <%-- Refresh the page --%>
                    <c:redirect url="products.jsp" />
                </c:when>
                
                <c:otherwise>
                    <c:set var="newkey" value="${row.key}" />
                    <fmt:parseNumber var="oldvalue" type="number" value="${cookie[newkey].value}" />
                    <c:set var="newvalue" value="${oldvalue + 1}" />
                    <%
                    String newkey = pageContext.getAttribute("newkey").toString();
                    //Integer newvalue = Integer.parseInt(pageContext.getAttribute("oldvalue").toString()) + 1;
                    Cookie newCookie = new Cookie(pageContext.getAttribute("newkey").toString(), pageContext.getAttribute("newvalue").toString());
                    newCookie.setMaxAge(365 * 60 * 60 * 24);
                    response.addCookie(newCookie);
                    %>
                    <fmt:parseNumber var="oldvalue" type="number" value="${cookie.total.value}" />
                    <c:set var="newvalue" value="${oldvalue + 1}" />
                    <%
                    Cookie totalCookie = new Cookie("total", pageContext.getAttribute("newvalue").toString());
                    totalCookie.setMaxAge(365 * 60 * 60 * 24);
                    response.addCookie(totalCookie);
                    %>
                    <c:redirect url="products.jsp" />
                </c:otherwise>
                
            </c:choose>
        </c:forEach>
    </c:when>
</c:choose>

<%-- Display product list with buttons --%>
<form action="products.jsp">
<table border="1" width="100%">
    <tr>
        <td>Product ID</td>
        <td>Product Description</td>
        <td>Product Price</td>
        <c:if test="${cookie.login.value.equals('true')}">
            <td>Quantity you want to buy</td>
        </c:if>
        <td>Add Button</td>
    </tr>
    <c:forEach var="row" items="${result.rows}">
    <tr>
        <td><c:out value="${row.pid}"/></td>
        <td><c:out value="${row.description}"/></td>
        <td><c:out value="${row.price}"/></td>
        <td><c:choose>
            <c:when test="${! empty cookie[row.pid]}">
            <c:out value="${cookie[row.pid].value}" />
            </c:when>
            <c:otherwise>
            0
            </c:otherwise>
        </c:choose></td>
        <c:if test="${cookie.login.value.equals('true')}">
            <td><input type="submit" name="${row.pid}" value="Add"></td>
        </c:if>
    </tr>
    </c:forEach>
</table>

    Total items you have chosen:
    <c:choose>
        <c:when test="${! empty cookie.total}">
            <c:out value="${cookie.total.value}"></c:out>
        </c:when>
        <c:otherwise>
            <c:out value="0"></c:out>
        </c:otherwise>
    </c:choose>
    <br />
    
    <input type="submit" name="reset" value="Reset">
    <input type="submit" name="submit" value="Go to cart">
</form>
<a href ='index.jsp'>Return to index page</a>
</center>
</body>
