<<<<<<< HEAD
import React from 'react';
import "../styles/RestartGameModal.scss";

interface ConfirmationModalProps {
	message: string;
	onConfirm: () => void;
	onCancel: () => void;
}

const ConfirmationModal: React.FC<ConfirmationModalProps> = ({message, onConfirm, onCancel}) => {
  return (
	<div className="restartCon">
		<div className="innerRestart">
			<p>{message}</p>
			<div className="chooseAns">
				<button onClick={onConfirm}>Yes</button>
				<button onClick={onCancel}>No</button>
			</div>
		</div>
	</div>
  )
}

=======
import React from 'react';
import "../styles/RestartGameModal.scss";

interface ConfirmationModalProps {
	message: string;
	onConfirm: () => void;
	onCancel: () => void;
	extraMessage: string;
}

const ConfirmationModal: React.FC<ConfirmationModalProps> = ({message, onConfirm, onCancel, extraMessage}) => {
  return (
	<div className="restartCon">
		<div className="innerRestartCon">
		<div className="innerRestart">
			<p className='restartMessage'>{message}<br /> {extraMessage}</p>
			<div className="chooseAns">
			<button onClick={onCancel}><span>No</span></button>
			<button onClick={onConfirm}><span>Yes</span></button>
				
			</div>
		</div>
		</div>
		
	</div>
  )
}

>>>>>>> c43c6f1d481754a137db14df3d2d25dbafa13db0
export default ConfirmationModal;