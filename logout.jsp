<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%-- All cookie data should be reset when logout, otherwise any new login user can see previous user's information --%>
<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost/ShoppingBasket"
    user="root"  password="asdfghjk"/>
<sql:query dataSource="${snapshot}" sql="SELECT * FROM Products;" var="result" />

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

<%
Cookie loginCookie = new Cookie("login", "false");
//Unit: second
loginCookie.setMaxAge(365*60*60*24); 
response.addCookie(loginCookie);

response.sendRedirect("index.jsp");
%>