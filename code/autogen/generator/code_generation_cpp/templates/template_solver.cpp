#include <Eigen/Dense>
#include "mex.h"
#if $(use_sparse_template)
#include <Eigen/Sparse>
#endif
#if $(use_sturm_eigensolver)
#define MAX_DEG  $(num_basis)
#include "sturm.h"
#include "charpoly.h"
#endif
#if $(use_sturm_dani_eigensolver)
#define MAX_DEG  $(num_basis)
#include "sturm.h"
#include "charpoly.h"
#endif

using namespace Eigen;

#if $(use_reduced_eigenvector_solver)
void fast_eigenvector_solver(double * eigv, int neig, Eigen::Matrix<double,$(num_basis),$(num_basis)> &AM, Matrix<std::complex<double>,$(num_vars),$(num_basis)> &sols);
#endif


MatrixXcd solver_$(solv_name)(const VectorXd& data)
{
	// Compute coefficients
$(code_compute_coefficients)

	// Setup elimination template
	static const int coeffs0_ind[] = { $(coeffs0_ind) };
	static const int coeffs1_ind[] = { $(coeffs1_ind) };
#if $(use_dense_template_stack_alloc)
	static const int C0_ind[] = { $(C0_ind) } ;
	static const int C1_ind[] = { $(C1_ind) };

	Matrix<double,$(C0_sz)> C0; C0.setZero();
	Matrix<double,$(C1_sz)> C1; C1.setZero();
	for (int i = 0; i < $(length_C0_ind); i++) { C0(C0_ind[i]) = coeffs(coeffs0_ind[i]); }
	for (int i = 0; i < $(length_C1_ind); i++) { C1(C1_ind[i]) = coeffs(coeffs1_ind[i]); } 

	Matrix<double,$(C1_sz)> C12 = C0.partialPivLu().solve(C1);
#endif
#if $(use_dense_template_heap_alloc)
	static const int C0_ind[] = { $(C0_ind) } ;
	static const int C1_ind[] = { $(C1_ind) };

	MatrixXd C0 = MatrixXd::Zero($(C0_sz));
	MatrixXd C1 = MatrixXd::Zero($(C1_sz));
	for (int i = 0; i < $(length_C0_ind); i++) { C0(C0_ind[i]) = coeffs(coeffs0_ind[i]); }
	for (int i = 0; i < $(length_C1_ind); i++) { C1(C1_ind[i]) = coeffs(coeffs1_ind[i]); } 

	MatrixXd C12 = C0.partialPivLu().solve(C1);
#endif
#if $(use_sparse_template)
	static const int C0_outer_indices[] = { $(C0_outer_ind) };
	static const int C0_inner_indices[] = { $(C0_inner_ind) };
	static const int C1_outer_indices[] = { $(C1_outer_ind) };
	static const int C1_inner_indices[] = { $(C1_inner_ind) };

	VectorXd C0_values($(length_C0_ind));
	VectorXd C1_values($(length_C1_ind));
	for (int i = 0; i < $(length_C0_ind); i++) { C0_values[i] = coeffs(coeffs0_ind[i]); }
	for (int i = 0; i < $(length_C1_ind); i++) { C1_values[i] = coeffs(coeffs1_ind[i]); }
	const SparseMatrix<double> C0 = Map<const SparseMatrix<double>>($(C0_sz),$(length_C0_ind),C0_outer_indices,C0_inner_indices,C0_values.data());
	const SparseMatrix<double> C1 = Map<const SparseMatrix<double>>($(C1_sz),$(length_C1_ind),C1_outer_indices,C1_inner_indices,C1_values.data());

	SparseLU<SparseMatrix<double>, COLAMDOrdering<SparseMatrix<double>::StorageIndex>> solver;
	solver.compute(C0);
	MatrixXd C12 = solver.solve(C1);
#endif

	// Setup action matrix
	Matrix<double,$(num_available), $(num_basis)> RR;
	RR << -C12.bottomRows($(num_reducible)), Matrix<double,$(num_basis),$(num_basis)>::Identity($(num_basis), $(num_basis));

	static const int AM_ind[] = { $(AM_ind) };
	Matrix<double, $(num_basis), $(num_basis)> AM;
	for (int i = 0; i < $(num_basis); i++) {
		AM.row(i) = RR.row(AM_ind[i]);
	}

	Matrix<std::complex<double>, $(num_vars), $(num_basis)> sols;
	sols.setZero();

	// Solve eigenvalue problem
#if $(use_standard_eigensolver)
	EigenSolver<Matrix<double, $(num_basis), $(num_basis)> > es(AM);
	ArrayXcd D = es.eigenvalues();	
	ArrayXXcd V = es.eigenvectors();
$(code_normalize_eigenvectors)
$(code_extract_solutions)
#endif
#if $(use_eigsonly_eigensolver)

	EigenSolver<MatrixXd> es(AM, false);
	ArrayXcd D = es.eigenvalues();

	int nroots = 0;
	double eigv[$(num_basis)];
	for (int i = 0; i < $(num_basis); i++) {
		if (std::abs(D(i).imag()) < 1e-6)
			eigv[nroots++] = D(i).real();
	}

	fast_eigenvector_solver(eigv, nroots, AM, sols);
#endif
#if $(use_sturm_eigensolver)
	double p[1+$(num_basis)];
	Matrix<double, $(num_basis), $(num_basis)> AMp = AM;
	charpoly_$(charpoly_method)(AMp, p);	
	double roots[$(num_basis)];
	int nroots;
	find_real_roots_sturm(p, $(num_basis), roots, &nroots, 8, 0);
	fast_eigenvector_solver(roots, nroots, AM, sols);
#endif

#if $(use_sturm_dani_eigensolver)
	double p[1 + $(num_basis)];
	Matrix<double, $(num_basis), $(num_basis)> T;
	charpoly_danilevsky_piv_T(AM, p, T);
	double roots[$(num_basis)];
	int nroots;
	find_real_roots_sturm(p, $(num_basis), roots, &nroots, 8, 0);	

	Matrix<double, $(num_basis), 1> v;
	for (int i = 0; i < nroots; i++) {
		v($(num_basis) - 1) = 1.0;
		// Compute eigenvector to companion matrix
		for (int j = $(num_basis) - 2; j >= 0; j--)
			v(j) = roots[i] * v(j + 1);
		// Transform to eigenvector of action matrix
		v = T * v;
		// TODO: support more fancy extraction schemes 
$(code_extract_solutions)
	}
#endif
	return sols;
}
$(debug_comments)

#if $(use_reduced_eigenvector_solver)
void fast_eigenvector_solver(double * eigv, int neig, Eigen::Matrix<double,$(num_basis),$(num_basis)> &AM, Matrix<std::complex<double>,$(num_vars),$(num_basis)> &sols) {
	static const int ind[] = { $(ind_non_trivial) };	
	// Truncated action matrix containing non-trivial rows
	Matrix<double, $(length_ind_non_trivial), $(num_basis)> AMs;
	double zi[$(max_power)];
	
	for (int i = 0; i < $(length_ind_non_trivial); i++)	{
		AMs.row(i) = AM.row(ind[i]);
	}
	for (int i = 0; i < neig; i++) {
		zi[0] = eigv[i];
		for (int j = 1; j < $(max_power); j++)
		{
			zi[j] = zi[j - 1] * eigv[i];
		}
		Matrix<double, $(AA_sz)> AA;
$(code_setup_reduced_eigenvalue_eq)

		Matrix<double, $(ind_unit), 1>  s = AA.leftCols($(ind_unit)).colPivHouseholderQr().solve(-AA.col($(ind_unit)));
$(code_extract_solutions)
	}
}
#endif


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs != 1) {
		mexErrMsgIdAndTxt("automatic_generator_cvpr:$(solv_name):nrhs", "One input required.");
	}
	if (nlhs != 1) {
		mexErrMsgIdAndTxt("automatic_generator_cvpr:$(solv_name):nlhs", "One output required.");
	}    
	if (!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0])) {
		mexErrMsgIdAndTxt("automatic_generator_cvpr:$(solv_name):notDouble", "Input data must be type double.");
	}
	if(mxGetNumberOfElements(prhs[0]) % $(input_size) != 0) {
		mexErrMsgIdAndTxt("automatic_generator_cvpr:$(solv_name):incorrectSize", "Input size must be multiple of $(input_size).");
	}
	int n_instances = mxGetNumberOfElements(prhs[0]) / $(input_size);
	double *input = mxGetPr(prhs[0]);
	plhs[0] = mxCreateDoubleMatrix($(num_vars),$(num_basis)*n_instances,mxCOMPLEX);
	double* zr = mxGetPr(plhs[0]);
	double* zi = mxGetPi(plhs[0]);
	for(int k = 0; k < n_instances; k++) {
		const VectorXd data = Map<const VectorXd>(input + k*$(input_size), $(input_size));
		MatrixXcd sols = solver_$(solv_name)(data);
		Index offset = k*sols.size();
		for (Index i = 0; i < sols.size(); i++) {
			zr[i+offset] = sols(i).real();
			zi[i+offset] = sols(i).imag();
		}
	}
}

