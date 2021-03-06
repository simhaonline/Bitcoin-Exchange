{% extends 'admin-layout.swig' %}
{% set title = 'Withdrawal Requests' %}
{% block body %}

	<div class="row wrapper border-bottom white-bg page-heading">
		<div class="col-sm-6">
			<h2>Withdrawal Requests</h2>
			<ol class="breadcrumb">
				<li>
					Admin
				</li>
				<li class="active">
					<strong>Cashouts</strong>
				</li>
			</ol>
		</div>
    <div class="col-sm-6 text-right">
      <h2>Request Total: &#8358; {{ total | formatCurrency }}</h1>
    </div>
	</div>

	<div class="wrapper wrapper-content">
		<div class="animated fadeInRight">
			<div class="row">
				<div class="col-md-12">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
              <div class="row">
                <div class="col-md-6"><h4 style="margin-top: 12px">Withdrawal Requests</h4></div>
                <div class="col-md-6 text-right"><a href="/withdrawals/completed" class="btn btn-danger">View Cashouts</a></div>
              </div>
						</div>
						<div class="ibox-content">
							<table class="table table-striped">
								<thead>
								<tr>
									<th>Date</th>
									<th>User Name</th>
									<th>Bank</th>
                  <th>Account Name</th>
                  <th>Account Number</th>
									<th class="text-right">Amount</th>
									<th>Status</th>
									<th class="text-center">Action</th>
								</tr>
								</thead>
								<tbody id="tb-transactions">
								{% for req in requests %}
									<tr id="{{ req.id }}">
										<td>{{ req.createdAt | date('d-m-Y H:i') }}</td>
										<td>{{ req.user.fullname }}</td>
										<td>{{ req.beneficiary.bank }}</td>
                    <td>{{ req.beneficiary.account_name }}</td>
                    <td>{{ req.beneficiary.account_number }}</td>                   
										<td class="text-right">&#8358;{{ req.amount | formatCurrency }}</td>
										<td>{{ req.status }}</td>
										<td class="text-center opt-icons">
											<a href="" class="approve" data-toggle="tooltip" title="Approve payment"><i class="fa fa-check fa-lg"></i> </a>
											<a href="" class="remove" data-toggle="tooltip" title="Cancel Request"><i class="fa fa-trash-o fa-lg"></i> </a>
										</td>
									</tr>
								{% endfor %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

{% endblock %}

{% block script %}
$(".approve").click(function(e) {
	e.preventDefault();
	if (!confirm("Are you sure you want to confirm this payout request?")) {
		return false;
	}
	var $parentTr = $(this).parents('tr');
	var id = $parentTr.attr('id');
	$.post('/withdrawal/mark-complete', { 'id': id }, function(d) {
		if (d.status.trim() == 'success') {
			$parentTr.find('td:nth-child(7)').text('Completed');
		}
	});
});


$(function() {
	$('[data-toggle="tooltip"]').tooltip();
});