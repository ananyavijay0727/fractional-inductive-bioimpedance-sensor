function result = diagnose_electrolytes(na_mM, k_mM, cl_mM)
% DIAGNOSE_ELECTROLYTES  Threshold-based health-status flags.
%
% Implements the clinical threshold lookup of the project report (Table 3.7).
% Inputs are sweat concentrations in mmol/L. Each output field has the
% value, a status (Normal / Borderline / Abnormal / Below table range)
% and a note.
%
% Example:
%   r = diagnose_electrolytes(55, 8, 72);
%   disp(r.chloride.status)      % Abnormal
%
% Research prototype. The thresholds are those used in the project report
% and have not been clinically validated. Not a medical device.

result.sodium    = classify_ion(na_mM, 'Na');
result.potassium = classify_ion(k_mM,  'K');
result.chloride  = classify_ion(cl_mM, 'Cl');
end

function out = classify_ion(value, ion)
note = '';
switch ion
    case 'Na'
        if value > 70
            status = 'Abnormal';   note = 'hypernatraemia / severe dehydration';
        elseif value > 60
            status = 'Borderline';
        elseif value >= 10
            status = 'Normal';
        else
            status = 'Below table range';
        end
    case 'K'
        if value > 12
            status = 'Abnormal';   note = 'muscle fatigue / metabolic distress';
        elseif value > 10
            status = 'Borderline';
        elseif value >= 4
            status = 'Normal';
        else
            status = 'Below table range';
        end
    case 'Cl'
        if value >= 60
            status = 'Abnormal';   note = 'cystic fibrosis positive indication';
        elseif value >= 30
            status = 'Borderline';
        else
            status = 'Normal';
        end
end
out = struct('value_mM', value, 'status', status, 'note', note);
end
