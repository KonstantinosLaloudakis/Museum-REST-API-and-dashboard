<!DOCTYPE html>
<html lang="en">

<?php
require 'php/connect.php';
?>

<head>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">

	<title>MUSEUM DASHBOARD</title>

	<!-- Custom fonts for this template-->
	<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
	<link
		href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
		rel="stylesheet">
	<link href="css/sb-admin-2.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css"
		integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
	<!-- Custom styles for this template-->


</head>

<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<!-- Sidebar -->
		<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

			<!-- Sidebar - Brand -->
			<a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.php">
				<div class="sidebar-brand-icon rotate-n-15">
					<i class="fas fa-thin fa-landmark"></i>
				</div>
				<div class="sidebar-brand-text mx-3">Museum dashboard</div>
			</a>

			<!-- Divider -->
			<hr class="sidebar-divider my-0">

			<!-- Nav Item - Dashboard -->
			<li class="nav-item active">
				<a class="nav-link" href="index.php">
					<i class="fas fa-solid fa-landmark"></i>
					<span>Αρχική Σελίδα</span></a>
			</li>

			<!-- Divider -->
			<hr class="sidebar-divider">

			<!-- Heading -->
			<div class="sidebar-heading">
				Γραφηματα
			</div>

			<li class="nav-item">
				<a class="nav-link" href="html/visitorsPerHour.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Επισκέπτες ανά ώρα</span></a>
			</li>
			<!-- Nav Item - Charts -->
			<li class="nav-item ">
				<a class="nav-link" href="html/visitsPerHour.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Επισκέψεις εκθεμάτων ανά ώρα</span></a>
			</li>

			<!-- Nav Item - Charts -->
			<li class="nav-item">
				<a class="nav-link" href="html/visitsPerExhibit.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Επισκέψεις ανά έκθεμα</span></a>
			</li>
			<!-- Nav Item - Charts -->
			<li class="nav-item">
				<a class="nav-link" href="html/revisitability.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Επανεπισκεψιμότητα / Δύναμη Έλξης</span></a>
			</li>
			<!-- Nav Item - Charts -->
			<li class="nav-item">
				<a class="nav-link" href="html/visitsPerDay.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Επισκέψεις εκθεμάτων ανά μέρα</span></a>
			</li>
			<!-- Nav Item - Charts -->
			<li class="nav-item">
				<a class="nav-link" href="html/timePerExhibit.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Χρόνος θέασης ανά έκθεμα</span></a>
			</li>
			<!-- Nav Item - Charts -->

			<li class="nav-item ">
				<a class="nav-link" href="html/routeIds.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Προτεινόμενες διαδρομές</span></a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="html/visitorTypes.html">
					<i class="fas fa-fw fa-chart-area"></i>
					<span>Κατηγορίες Επισκεπτών </span></a>
			</li>
			<!-- Nav Item - Tables -->
			<li class="nav-item">
				<a class="nav-link" href="html/analytics.html">
					<i class="fas fa-fw fa-table"></i>
					<span>Περισσότερα...</span></a>
			</li>
			<!-- Divider -->
			<hr class="sidebar-divider d-none d-md-block">

			<!-- Sidebar Toggler (Sidebar) -->
			<div class="text-center d-none d-md-inline">
				<button class="rounded-circle border-0" id="sidebarToggle"></button>
			</div>

			<!-- Sidebar Message -->
			<!--  <div class="sidebar-card d-none d-lg-flex">
				<img class="sidebar-card-illustration mb-2" src="img/undraw_rocket.svg" alt="...">
				<p class="text-center mb-2"><strong>SB Admin Pro</strong> is packed with premium features, components, and more!</p>
				<a class="btn btn-success btn-sm" href="https://startbootstrap.com/theme/sb-admin-pro">Upgrade to Pro!</a>
			</div>
 -->
		</ul>
		<!-- End of Sidebar -->

		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

					<!-- Sidebar Toggle (Topbar) -->
					<button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
						<i class="fa fa-bars"></i>
					</button>





				</nav>
				<!-- End of Topbar -->

				<!-- Begin Page Content -->
				<div class="container-fluid">

					<?php

					$sqll = "SELECT
					SUM(uniqueVisitors) AS totalUniqueVisitors
				FROM (
					SELECT
						DATE(FROM_UNIXTIME(timeIn)) AS visitDate,
						COUNT(DISTINCT visitorId) AS uniqueVisitors
					FROM groupeddata
					GROUP BY visitDate
				) AS subquery;";

					if (mysqli_query($conn, $sqll)) {

						echo "";

					} else {

						echo "Error: " . $sqll . "<br>" . mysqli_error($conn);

					}

					$result = mysqli_query($conn, $sqll);

					if (mysqli_num_rows($result) > 0) {

						// output data of each row
					
						while ($row = mysqli_fetch_assoc($result)) {

							?>
							<!-- Content Row -->
							<div class="row">

								<!-- Earnings (Monthly) Card Example -->
								<div class="col-xl-3 col-md-6 mb-4">
									<div class="card border-left-primary shadow h-100 py-2">
										<div class="card-body">
											<div class="row no-gutters align-items-center">
												<div class="col mr-2">
													<div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
														ΣΥΝΟΛΙΚΟΙ ΕΠΙΣΚΕΠΤΕΣ</div>
													<div class="h5 mb-0 font-weight-bold text-gray-800">
														<?php echo $row['totalUniqueVisitors']; ?>
													</div>
												</div>
												<div class="col-auto">
													<i class="fas fa-user fa-2x text-gray-300"></i>
												</div>
											</div>
										</div>
									</div>
								</div>
								<?php

						}

					} else {

						echo '0 results';

					}

					?>

						<?php

						$sqll = "SELECT  Count(*) as vipVisitors from vipvisitorsinfo";

						if (mysqli_query($conn, $sqll)) {

							echo "";

						} else {

							echo "Error: " . $sqll . "<br>" . mysqli_error($conn);

						}

						$result = mysqli_query($conn, $sqll);

						if (mysqli_num_rows($result) > 0) {

							// output data of each row
						
							while ($row = mysqli_fetch_assoc($result)) {

								?>
								<!-- Earnings (Monthly) Card Example -->
								<div class="col-xl-3 col-md-6 mb-4">
									<div class="card border-left-success shadow h-100 py-2">
										<div class="card-body">
											<div class="row no-gutters align-items-center">
												<div class="col mr-2">
													<div class="text-xs font-weight-bold text-success text-uppercase mb-1">
														ΕΠΩΝΥΜΟΙ ΕΠΙΣΚΕΠΤΕΣ</div>
													<div class="h5 mb-0 font-weight-bold text-gray-800">
														<?php echo $row['vipVisitors']; ?>
													</div>
												</div>
												<div class="col-auto">
													<i class="fas fa-star fa-2x text-gray-300"></i>
												</div>
											</div>
										</div>
									</div>
								</div>
								<?php

							}

						} else {

							echo '0 results';

						}

						?>

						<?php

						$sqll = "SELECT COUNT(DISTINCT SUBSTRING_INDEX(roomName, '.', 1)) AS totalBuildings FROM cellids";


						if (mysqli_query($conn, $sqll)) {

							echo "";

						} else {

							echo "Error: " . $sqll . "<br>" . mysqli_error($conn);

						}

						$result = mysqli_query($conn, $sqll);

						if (mysqli_num_rows($result) > 0) {

							// output data of each row
						
							while ($row = mysqli_fetch_assoc($result)) {
								?>
								<!-- Earnings (Monthly) Card Example -->
								<div class="col-xl-3 col-md-6 mb-4">
									<div class="card border-left-info shadow h-100 py-2">
										<div class="card-body">
											<div class="row no-gutters align-items-center">
												<div class="col mr-2">
													<div class="text-xs font-weight-bold text-info text-uppercase mb-1">ΚΤΙΡΙΑ
													</div>
													<div class="row no-gutters align-items-center">
														<div class="col-auto">
															<div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">
																<?php echo $row['totalBuildings']; ?>
															</div>
														</div>
													</div>
												</div>
												<div class="col-auto">
													<i class="fas fa-landmark fa-2x text-gray-300"></i>
												</div>
											</div>
										</div>
									</div>
								</div>
								<?php

							}

						} else {
							echo '0 results';
						}

						?>

						<?php

						$sqll = "SELECT  COUNT(*) as totalVisits from groupeddata";

						if (mysqli_query($conn, $sqll)) {
							echo "";
						} else {
							echo "Error: " . $sqll . "<br>" . mysqli_error($conn);
						}

						$result = mysqli_query($conn, $sqll);

						if (mysqli_num_rows($result) > 0) {

							// output data of each row
						
							while ($row = mysqli_fetch_assoc($result)) {

								?>
								<!-- Pending Requests Card Example -->
								<div class="col-xl-3 col-md-6 mb-4">
									<div class="card border-left-warning shadow h-100 py-2">
										<div class="card-body">
											<div class="row no-gutters align-items-center">
												<div class="col mr-2">
													<div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
														ΣΥΝΟΛΙΚΕΣ ΕΠΙΣΚΕΨΕΙΣ ΕΚΘΕΜΑΤΩΝ</div>
													<div class="h5 mb-0 font-weight-bold text-gray-800">
														<?php echo $row['totalVisits']; ?>
													</div>
												</div>
												<div class="col-auto">
													<i class="fas fa-door-open fa-2x text-gray-300"></i>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<?php
							}
						} else {
							echo '0 results';
						}
						?>
					<div class="col-12 mt-4">
						<div class="row">
							<?php

							$sqll = "SELECT g.cellId, c.roomName AS roomName, COUNT(*) AS totalVisits
							FROM groupeddata AS g
							INNER JOIN cellids AS c ON g.cellId = c.id
							GROUP BY g.cellId
							ORDER BY totalVisits DESC
							LIMIT 1";

							if (mysqli_query($conn, $sqll)) {
								echo "";
							} else {
								echo "Error: " . $sqll . "<br>" . mysqli_error($conn);
							}

							$result = mysqli_query($conn, $sqll);

							if (mysqli_num_rows($result) > 0) {

								// output data of each row
							
								while ($row = mysqli_fetch_assoc($result)) {
									?>
									<div class="col-md-4">
										<div class="card text-white bg-primary mb-3" style="max-width: 18rem;">
											<div class="card-header">Το πιο δημοφιλές έκθεμα </div>
											<div class="card-body">
												<h5 class="card-title">
													<?php echo $row['roomName']; ?> <i class="fas fa-fire"></i>
												</h5>
												<p class="card-text">ΤΟ ΠΙΟ ΔΗΜΟΦΙΛΕΣ ΕΚΘΕΜΑ ΣΕ ΟΛΟ ΤΟ ΜΟΥΣΕΙΟ ΜΕ
													<b>
														<?php echo $row['totalVisits']; ?> ΕΠΙΣΚΕΨΕΙΣ.
													</b>
												</p>
											</div>
										</div>
									</div>
									<?php
								}
							} else {
								echo '0 results';
							}
							?>
							<?php
							// Calculate the date 3 months ago from the current date
							$threeMonthsAgo = date('Y-m-d', strtotime('-3 months'));

							$sqll = "SELECT g.cellId, c.roomName AS roomName, COUNT(*) AS totalVisits
							FROM groupeddata AS g
							INNER JOIN cellids AS c ON g.cellId = c.id
							WHERE DATE(FROM_UNIXTIME(g.timeIn)) >= '$threeMonthsAgo'
							GROUP BY g.cellId
							ORDER BY totalVisits DESC
							LIMIT 1";

							if (mysqli_query($conn, $sqll)) {
								echo "";
							} else {
								echo "Error: " . $sqll . "<br>" . mysqli_error($conn);
							}

							$result = mysqli_query($conn, $sqll);

							if (mysqli_num_rows($result) > 0) {

								// output data of each row
							
								while ($row = mysqli_fetch_assoc($result)) {

									?>
									<div class="col-md-4">

										<div class="card text-white bg-success mb-3" style="max-width: 18rem;">
											<div class="card-header">Δημοφιλέστερο έκθεμα προηγούμενου τριμήνου</div>
											<div class="card-body">
												<h5 class="card-title">
													<?php echo $row['roomName']; ?> <i class="fas fa-fire"></i>
												</h5>
												<p class="card-text">ΤΟ ΠΙΟ ΔΗΜΟΦΙΛΕΣ ΕΚΘΕΜΑ ΓΙΑ ΤΟ ΠΡΟΗΓΟΥΜΕΝΟ ΤΡΙΜΗΝΟ ΜΕ
													<b>
														<?php echo $row['totalVisits']; ?> ΕΠΙΣΚΕΨΕΙΣ.
													</b>
												</p>
											</div>
										</div>
									</div>


									<?php

								}

							} else {
								echo '0 results';
							}
							?>
							<?php
							// Calculate the date 1 month ago from the current date
							$oneMonthAgo = date('Y-m-d', strtotime('-1 month'));

							$sqll = "SELECT g.cellId, c.roomName AS roomName, COUNT(*) AS totalVisits
							FROM groupeddata AS g
							INNER JOIN cellids AS c ON g.cellId = c.id
							WHERE DATE(FROM_UNIXTIME(g.timeIn)) >= '$oneMonthAgo'
							GROUP BY g.cellId
							ORDER BY totalVisits DESC
							LIMIT 1";

							if (mysqli_query($conn, $sqll)) {
								echo "";
							} else {
								echo "Error: " . $sqll . "<br>" . mysqli_error($conn);
							}

							$result = mysqli_query($conn, $sqll);

							if (mysqli_num_rows($result) > 0) {

								// output data of each row
							
								while ($row = mysqli_fetch_assoc($result)) {
									?>
									<div class="col-md-4">
										<div class="card text-white bg-danger mb-3" style="max-width: 18rem;">
											<div class="card-header">Δημοφιλέστερο έκθεμα προηγούμενου μήνα</div>
											<div class="card-body">
												<h5 class="card-title">
													<?php echo $row['roomName']; ?> <i class="fas fa-fire"></i>
												</h5>
												<p class="card-text">ΤΟ ΠΙΟ ΔΗΜΟΦΙΛΕΣ ΕΚΘΕΜΑ ΓΙΑ ΤΟΝ ΠΡΟΗΓΟΥΜΕΝΟ ΜΗΝΑ ΜΕ
													<b>
														<?php echo $row['totalVisits']; ?> ΕΠΙΣΚΕΨΕΙΣ.
													</b>
												</p>
											</div>
										</div>
									</div>


									<?php

								}

							} else {
								// Display a message when there are no results
								?>
								<div class="col-md-4">
									<div class="card text-white bg-primary mb-3" style="max-width: 18rem;">
										<div class="card-header">Δημοφιλέστερο έκθεμα προηγούμενου μήνα</div>
										<div class="card-body">
											<h5 class="card-title">-</h5>
											<p class="card-text">ΔΕΝ ΥΠΗΡΧΑΝ ΕΠΙΣΚΕΨΕΙΣ ΑΥΤΟ ΤΟ ΔΙΑΣΤΗΜΑ</p>
										</div>
									</div>
								</div>
								<?php
							}


							?>
						</div> <!-- cards -->
					</div>
				</div>

			</div>
			<!-- End of Content Wrapper -->
		</div>
		<!-- End of Page Wrapper -->

		<!-- Scroll to Top Button-->
		<a class="scroll-to-top rounded" href="#page-top">
			<i class="fas fa-angle-up"></i>
		</a>

		<!-- Logout Modal-->
		<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
			aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
						<button class="close" type="button" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">×</span>
						</button>
					</div>
					<div class="modal-body">Select "Logout" below if you are ready to end your current session.
					</div>
					<div class="modal-footer">
						<button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
						<a class="btn btn-primary" href="login.html">Logout</a>
					</div>
				</div>
			</div>
		</div>

		<!-- Bootstrap core JavaScript-->
		<script src="vendor/jquery/jquery.min.js"></script>
		<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

		<!-- Core plugin JavaScript-->
		<script src="vendor/jquery-easing/jquery.easing.min.js"></script>

		<!-- Custom scripts for all pages-->
		<script src="js/sb-admin-2.js"></script>

</body>

</html>