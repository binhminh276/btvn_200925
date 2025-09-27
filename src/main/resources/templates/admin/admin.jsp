<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-
EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-
beta2/css/all.min.css"
	integrity="sha512-
YWzhKL2whUzgiheMoBFwW8CKV4qpHQAEuvilg9FAn5VJUDwKZZxkJNuGM4XkWuk94WCrrwslk8yWNGmY1EduT
A=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/css/mystyles.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/fontawesome/6.1.1/css/all.min.css"
	integrity="sha512-
KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0
g=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css"
	rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script>
	var contextPath = "${pageContext.request.contextPath}"
</script>
<title>Index</title>
</head>
<body>
	<header class="row">
		<div class="col">
			<%@include file="/common/admin/header.jsp"%>
		</div>
	</header>
	<main class="container-fluid">
		<!-- <nav class ="row">
 <div class="col">
 <div></div>
 </div>
 </nav> -->
		<div class="row mt-4">
			<div class="col mt-5 mb-5">

				<sitemesh:write property='body'></sitemesh:write>


			</div>
		</div>


	</main>
	<footer class="row">
		<div class="col">
			<%@include file="/common/admin/footer.jsp"%>
		</div>
	</footer>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min
.js"
		integrity="sha384-
MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
</body>
</html>