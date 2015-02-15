<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost/ShoppingBasket"
    user="root"  password="asdfghjk"/>
<sql:query dataSource="${snapshot}" sql="SELECT * FROM Accounts WHERE aname = '${param.username}';" var="result" />

<c:choose>
    <c:when test="${param.password != param.cpassword}">
        <c:redirect url="error.jsp?errorInfo=Two passwords are not the same!"/>
    </c:when>
    <c:when test="${fn:length(result.rows) > 0}">
        <c:redirect url="error.jsp?errorInfo=Username you typed has been occupied!" />
    </c:when>
    <c:otherwise>
        <sql:update dataSource="${snapshot}" var="count">
            INSERT INTO Accounts VALUES ('${param.username}', SHA1('${param.password}'));
        </sql:update>
        <%
        Cookie useridCookie = new Cookie("userid", request.getParameter("username"));
        Cookie loginCookie = new Cookie("login", "true");
        // Unit: second
        useridCookie.setMaxAge(365 * 60 * 60 * 24);
        response.addCookie(useridCookie);
        response.addCookie(loginCookie);
        
        response.sendRedirect("index.jsp");
        %>
    </c:otherwise>
</c:choose>
